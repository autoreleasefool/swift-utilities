import Dependencies
import DependenciesMacros
import FileManagerPackageServiceInterface
import Foundation
@preconcurrency import GRDB
import GRDBDatabasePackageLibrary
import GRDBDatabasePackageServiceInterface

extension GRDBDatabaseService: DependencyKey {
	public static var liveValue: Self {
		let writer = LockIsolated<(any DatabaseWriter)?>(nil)

		return Self(
			initialize: { suppliedDbUrl, migrations, eraseDatabaseOnSchemaChange in
				@Dependency(GRDBInternalDatabaseService.self) var grdbInternal
				let value = try grdbInternal.initialize(
					dbUrl: suppliedDbUrl,
					migrations: migrations,
					eraseDatabaseOnSchemaChange: eraseDatabaseOnSchemaChange
				)

				writer.setValue(value.database)
			},
			close: {
				try writer.withValue {
					try $0?.close()
					$0 = nil
				}
			},
			reader: { writer.value! },
			writer: { writer.value! }
		)
	}
}

// MARK: - Internal

@DependencyClient
struct GRDBInternalDatabaseService: Sendable {
	var initialize: @Sendable (
		_ dbUrl: URL?,
		_ migrations: [Migration.Type],
		_ eraseDatabaseOnSchemaChange: Bool
	) throws -> GRDBInternalValue
}

extension GRDBInternalDatabaseService: TestDependencyKey {
	static var testValue: Self { Self() }
}

extension GRDBInternalDatabaseService: DependencyKey {
	public static var liveValue: GRDBInternalDatabaseService {
		return Self(
			initialize: { suppliedDbUrl, migrations, eraseDatabaseOnSchemaChange in
				@Dependency(\.fileManager) var fileManager

				let dbUrl: URL
				if let suppliedDbUrl {
					dbUrl = suppliedDbUrl
				} else {
					do {
						let folderUrl = try fileManager
							.getUserDirectory()
							.appending(path: "database", directoryHint: .isDirectory)

						try fileManager.createDirectory(folderUrl)

						dbUrl = folderUrl.appending(path: "db.sqlite")
					} catch {
						// FIXME: should notify user of failure to open DB
						fatalError("Unable to access database path: \(error)")
					}
				}

				do {
					let dbPool = try DatabasePool(path: dbUrl.path())
					var migrator = DatabaseMigrator()

					#if DEBUG
					migrator.eraseDatabaseOnSchemaChange = eraseDatabaseOnSchemaChange
					#endif

					for migration in migrations {
						migrator.register(migration: migration)
					}

					try migrator.migrate(dbPool)

					return GRDBInternalValue(
						databasePath: dbUrl,
						migrator: migrator,
						database: dbPool
					)
				} catch {
					// FIXME: should notify user of failure to open DB
					fatalError("Unable to access database: \(error)")
				}
			}
		)
	}
}

struct GRDBInternalValue: Sendable {
	let databasePath: URL
	let migrator: DatabaseMigrator
	let database: DatabaseWriter

	init(databasePath: URL, migrator: DatabaseMigrator, database: DatabaseWriter) {
		self.databasePath = databasePath
		self.migrator = migrator
		self.database = database
	}
}

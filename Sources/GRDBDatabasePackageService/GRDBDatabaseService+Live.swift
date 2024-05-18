import Dependencies
import FileManagerPackageServiceInterface
import Foundation
import GRDB
import GRDBDatabasePackageLibrary
import GRDBDatabasePackageServiceInterface

extension GRDBDatabaseService: DependencyKey {
	public static var liveValue: Self {
		let writer = LockIsolated<(any DatabaseWriter)?>(nil)

		return Self(
			initialize: { migrations, eraseDatabaseOnSchemaChange in
				@Dependency(\.fileManager) var fileManager

				let dbUrl: URL

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
					writer.setValue(dbPool)
				} catch {
					// FIXME: should notify user of failure to open DB
					fatalError("Unable to access database: \(error)")
				}
			},
			reader: { try writer.value.get() },
			writer: { try writer.value.get() }
		)
	}
}

extension GRDBDatabaseService {
	public enum ServiceError: Swift.Error {
		case notInitialized
	}
}

private extension Optional {
	func get() throws -> Wrapped {
		guard let self else {
			throw GRDBDatabaseService.ServiceError.notInitialized
		}

		return self
	}
}

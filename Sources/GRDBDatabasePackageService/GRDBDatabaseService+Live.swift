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
					writer.setValue(dbPool)
				} catch {
					fatalError("Unable to access database: \(error)")
				}
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

extension GRDBDatabaseService {
	public enum ServiceError: Swift.Error {
		case notInitialized
	}
}

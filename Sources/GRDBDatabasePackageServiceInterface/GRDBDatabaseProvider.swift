import Dependencies
import FileManagerPackageServiceInterface
import Foundation
import GRDB
import GRDBDatabasePackageLibrary

public final class GRDBDatabaseProvider: Sendable {
	private let _writer: DatabaseWriter

	public var reader: DatabaseReader {
		_writer
	}

	public var writer: DatabaseWriter {
		_writer
	}

	public init(
		url suppliedDbUrl: URL?,
		migrations: [Migration.Type],
		eraseDatabaseOnSchemaChange: Bool = false
	) {
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
			_writer = dbPool
		} catch {
			fatalError("Unable to access database: \(error)")
		}
	}

	deinit {
		try? _writer.close()
	}
}

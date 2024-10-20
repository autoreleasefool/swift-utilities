import Dependencies
import FileManagerPackageServiceInterface
import Foundation
import GRDB
import GRDBDatabasePackageLibrary
import GRDBDatabasePackageServiceInterface

extension GRDBDatabaseService: DependencyKey {
	public static var liveValue: Self {
		let instance = LockIsolated<GRDBDatabaseProvider?>(nil)

		return Self(
			initialize: { suppliedDbUrl, migrations, eraseDatabaseOnSchemaChange in
				instance.setValue(
					GRDBDatabaseProvider(
						url: suppliedDbUrl,
						migrations: migrations,
						eraseDatabaseOnSchemaChange: eraseDatabaseOnSchemaChange
					)
				)
			},
			close: {
				instance.setValue(nil)
			},
			reader: { instance.value!.reader },
			writer: { instance.value!.writer }
		)
	}
}

extension GRDBDatabaseService {
	public enum ServiceError: Swift.Error {
		case notInitialized
	}
}

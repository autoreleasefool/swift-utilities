import Dependencies
import DependenciesMacros
import GRDB
import GRDBDatabasePackageLibrary

@DependencyClient
public struct GRDBDatabaseService: Sendable {
	public var initialize: @Sendable (
		_ migrations: [Migration.Type],
		_ eraseDatabaseOnSchemaChange: Bool
	) throws -> Void
	public var reader: @Sendable () throws -> DatabaseReader
	public var writer: @Sendable () throws -> DatabaseWriter
}

extension GRDBDatabaseService: TestDependencyKey {
	public static var testValue = Self()
}

extension DependencyValues {
	public var grdb: GRDBDatabaseService {
		get { self[GRDBDatabaseService.self] }
		set { self[GRDBDatabaseService.self] = newValue }
	}
}

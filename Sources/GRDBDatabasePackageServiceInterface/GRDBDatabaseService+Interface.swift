import Dependencies
import DependenciesMacros
import Foundation
import GRDB
import GRDBDatabasePackageLibrary

@DependencyClient
public struct GRDBDatabaseService: Sendable {
	public var initialize: @Sendable (
		_ dbUrl: URL?,
		_ migrations: [Migration.Type],
		_ eraseDatabaseOnSchemaChange: Bool
	) throws -> Void
	public var close: @Sendable () throws -> Void
	public var reader: @Sendable () throws -> DatabaseReader
	public var writer: @Sendable () throws -> DatabaseWriter
}

extension GRDBDatabaseService: TestDependencyKey {
	public static var testValue: Self { Self() }
}

extension DependencyValues {
	public var grdb: GRDBDatabaseService {
		get { self[GRDBDatabaseService.self] }
		set { self[GRDBDatabaseService.self] = newValue }
	}
}

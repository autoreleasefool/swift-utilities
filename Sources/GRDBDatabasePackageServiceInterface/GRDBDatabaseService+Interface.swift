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
	public var reader: @Sendable () -> DatabaseReader = { unimplemented("\(Self.self).reader") }
	public var writer: @Sendable () -> DatabaseWriter = { unimplemented("\(Self.self).writer") }
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

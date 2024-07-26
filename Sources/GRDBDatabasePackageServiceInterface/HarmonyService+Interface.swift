import Dependencies
import DependenciesMacros
import Foundation
import GRDB
import GRDBDatabasePackageLibrary
import Harmony

public protocol HarmonicDatabaseReader {
	var reader: DatabaseReader { get }
	func read<T>(_ block: (Database) throws -> T) throws -> T
	func read<T>(_ block: @Sendable @escaping (Database) throws -> T) async throws -> T
}

public protocol HarmonicDatabaseWriter: HarmonicDatabaseReader {
	func create<T: HRecord>(record: T) async throws
	func create<T: HRecord>(records: [T]) async throws
	func save<T: HRecord>(record: T) async throws
	func save<T: HRecord>(records: [T]) async throws
	func delete<T: HRecord>(record: T) async throws
	func delete<T: HRecord>(records: [T]) async throws
}

@DependencyClient
public struct HarmonyService: Sendable {
	public var initialize: @Sendable (
		_ dbUrl: URL,
		_ recordTypes: [any HRecord.Type],
		_ migrations: [Migration.Type],
		_ eraseDatabaseOnSchemaChange: Bool
	) throws -> Void
	public var reader: @Sendable () -> HarmonicDatabaseReader = { unimplemented("\(Self.self).reader") }
	public var writer: @Sendable () -> HarmonicDatabaseWriter = { unimplemented("\(Self.self).writer") }
}

extension HarmonyService: TestDependencyKey {
	public static var testValue: Self { Self() }
}

extension DependencyValues {
	public var harmony: HarmonyService {
		get { self[HarmonyService.self] }
		set { self[HarmonyService.self] = newValue }
	}
}

import Dependencies
import GRDB
import GRDBDatabasePackageLibrary
@testable import GRDBDatabasePackageService
@testable import GRDBDatabasePackageServiceInterface
import TestUtilitiesPackageLibrary
import XCTest

final class GRDBDatabaseServiceTests: XCTestCase {
	@Dependency(\.grdb) var grdb

	override func tearDownWithError() throws {
		try? FileManager.default.removeItem(at: try Self.getTempFolder())
		try super.tearDownWithError()
	}

	private static func getTempFolder() throws -> URL {
		try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
			.appendingPathComponent("approach-tmp")
	}

	func test_initialize_createsDatabase() throws {
		let liveValue: GRDBDatabaseService = .liveValue
		let dbDestinationUrl = try Self.getTempFolder()
			.appending(path: "database")
			.appending(path: "db.sqlite")

		let existsBefore = FileManager.default.fileExists(atPath: dbDestinationUrl.path())
		XCTAssertFalse(existsBefore)

		try withDependencies {
			$0.fileManager.getUserDirectory = { @Sendable in try Self.getTempFolder() }
			$0.fileManager.createDirectory = { @Sendable in
				try FileManager.default
					.createDirectory(at: $0, withIntermediateDirectories: true)
			}
			$0.grdb.initialize = liveValue.initialize
		} operation: {
			try self.grdb.initialize(
				dbUrl: nil,
				migrations: [TestMigration.self],
				eraseDatabaseOnSchemaChange: false
			)
		}

		let existsAfter = FileManager.default.fileExists(atPath: dbDestinationUrl.path())
		XCTAssertTrue(existsAfter)
	}

	// MARK: reader

	func test_reader_beforeInitialize_throwsError() throws {
		try XCTSkipIf(true, "reader currently throws a fatalError")

//		let liveValue: GRDBDatabaseService = .liveValue
//
//		XCTAssertThrowsError(
//			_ = try withDependencies {
//				$0.grdb.reader = liveValue.reader
//			} operation: {
//				try self.grdb.reader()
//			}
//		)
	}

	// MARK: writer

	func test_writer_beforeInitialize_throwsError() throws {
		try XCTSkipIf(true, "writer currently throws a fatalError")

//		let liveValue: GRDBDatabaseService = .liveValue
//
//		XCTAssertThrowsError(
//			_ = try withDependencies {
//				$0.grdb.writer = liveValue.writer
//			} operation: {
//				try self.grdb.writer()
//			}
//		)
	}
}

private struct TestMigration: Migration {
	static func migrate(_ db: Database) throws {
		try db.create(table: "test") { t in
			t.column("id", .text)
				.primaryKey()
			t.column("name", .text)
				.notNull()
		}
	}
}

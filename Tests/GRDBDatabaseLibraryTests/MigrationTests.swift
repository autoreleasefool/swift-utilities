import GRDB
@testable import GRDBDatabaseLibrary
import XCTest

final class DBMigrationTests: XCTestCase {
	func testIdentifier() {
		XCTAssertEqual(
			TestMigration.identifier,
			"TestMigration"
		)
	}

	func testRegistersMigration() throws {
		var migrator = DatabaseMigrator()
		XCTAssertEqual(migrator.migrations, [])

		migrator.register(migration: TestMigration.self)
		XCTAssertEqual(migrator.migrations, ["TestMigration"])
	}

	func testRunsMigrations() throws {
		let dbQueue = try DatabaseQueue()
		var migrator = DatabaseMigrator()

		let appliedBefore = try dbQueue.read {
			try migrator.appliedMigrations($0)
		}
		XCTAssertEqual(appliedBefore, [])

		migrator.register(migration: TestMigration.self)
		try migrator.migrate(dbQueue)

		let appliedAfter = try dbQueue.read {
			try migrator.appliedMigrations($0)
		}
		XCTAssertEqual(appliedAfter, ["TestMigration"])
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

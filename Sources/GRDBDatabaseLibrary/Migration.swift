import GRDB

public protocol Migration {
	static var identifier: String { get }
	static func migrate(_ db: Database) throws
}

extension Migration {
	public static var identifier: String { "\(Self.self)" }
}

extension DatabaseMigrator {
	public mutating func register(migration: Migration.Type) {
		self.registerMigration(migration.identifier, migrate: migration.migrate(_:))
	}
}

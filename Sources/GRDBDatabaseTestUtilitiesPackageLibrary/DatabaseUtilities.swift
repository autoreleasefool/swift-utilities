import GRDB
import GRDBDatabasePackageLibrary

public enum InitialValue<T> {
	case `default`
	case custom([T])
	case zero
}

public func initializeDatabase(
	migrations: [Migration.Type],
	to db: (any DatabaseWriter)? = nil,
	body: (Database) throws -> Void = { _ in }
) throws -> any DatabaseWriter {
	let dbQueue: any DatabaseWriter
	if let db {
		dbQueue = db
	} else {
		dbQueue = try DatabaseQueue()
		var migrator = DatabaseMigrator()
		for migration in migrations {
			migrator.register(migration: migration)
		}
		try migrator.migrate(dbQueue)
	}

	#if DEBUG
	try dbQueue.write(body)
	#endif

	return dbQueue
}

public func coallesce<T>(_ value: InitialValue<T>?, ifHasAllOf: Any?...) -> InitialValue<T>? {
	if ifHasAllOf.compactMap({ $0 }).count < ifHasAllOf.count {
		return value
	} else {
		return value == nil ? .default : value
	}
}

public func coallesce<T>(_ value: InitialValue<T>?, ifHasOneOf: Any?...) -> InitialValue<T>? {
	if ifHasOneOf.compactMap({ $0 }).isEmpty {
		return value
	} else {
		return value == nil ? .default : value
	}
}

import Dependencies
import GRDB
import GRDBDatabasePackageLibrary
import GRDBDatabasePackageServiceInterface
import Harmony

extension Harmonic: HarmonicDatabaseReader {}
extension Harmonic: HarmonicDatabaseWriter {}

extension HarmonyService: DependencyKey {
	public static var liveValue: Self {
		let harmony = LockIsolated<Harmonic?>(nil)

		return Self(
			initialize: { dbUrl, recordTypes, migrations, eraseDatabaseOnSchemaChange in
				@Dependency(GRDBInternalDatabaseService.self) var grdbInternal

				let value = try grdbInternal.initialize(
					dbUrl: dbUrl,
					migrations: migrations,
					eraseDatabaseOnSchemaChange: eraseDatabaseOnSchemaChange
				)

				@Harmony(
					records: recordTypes,
					configuration: Configuration(
						databasePath: value.databasePath.path()
					),
					migrator: value.migrator
				) var harmonyInstance

				harmony.setValue(harmonyInstance)
			},
			reader: { harmony.value! },
			writer: { harmony.value! }
		)
	}
}

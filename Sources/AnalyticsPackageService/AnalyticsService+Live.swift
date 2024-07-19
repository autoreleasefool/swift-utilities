import AnalyticsPackageServiceInterface
import Dependencies
import OSLog

extension AnalyticsService: DependencyKey {
	public static var liveValue: Self {
		let optInStatus = LockIsolated<Analytics.OptInStatus>(.optedIn)
		let subsystem = "AnalyticsService"

		return Self(
			initialize: { },
			trackEvent: {
				let analyticsLogger = Logger(subsystem: subsystem, category: "analytics")
				analyticsLogger.log("\($0.name)")
			},
			setGlobalProperty: {
				let propertiesLogger = Logger(subsystem: subsystem, category: "properties")
				propertiesLogger.log("Setting \($0) to \($1 ?? "nil")")
			},
			getOptInStatus: { optInStatus.value },
			setOptInStatus: {
				optInStatus.setValue($0)
				return optInStatus.value
			}
		)
	}
}

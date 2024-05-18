import AnalyticsPackageServiceInterface
import Dependencies
import OSLog

extension Logger {
	private static var subsystem: String = "AnalyticsService"
	static let analytics = Logger(subsystem: subsystem, category: "analytics")
	static let properties = Logger(subsystem: subsystem, category: "properties")
}

extension AnalyticsService: DependencyKey {
	public static var liveValue: Self {
		let optInStatus = LockIsolated<Analytics.OptInStatus>(.optedIn)

		return Self(
			initialize: { },
			trackEvent: { Logger.analytics.log("\($0.name)") },
			setGlobalProperty: { Logger.properties.log("Setting \($0) to \($1 ?? "nil")") },
			getOptInStatus: { optInStatus.value },
			setOptInStatus: {
				optInStatus.setValue($0)
				return optInStatus.value
			}
		)
	}
}

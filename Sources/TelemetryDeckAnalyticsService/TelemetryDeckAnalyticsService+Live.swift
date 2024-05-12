import AnalyticsServiceInterface
import BundleServiceInterface
import Dependencies
import DependenciesMacros
import Foundation
import TelemetryClient
import UserDefaultsServiceInterface

extension AnalyticsService: DependencyKey {
	public static var liveValue: Self {
		let properties = ActorIsolated<[String: String]>([:])
		let userDefaultsOptInKey = "telemetryDeckAnalyticsOptIn"

		@Sendable func getOptInStatus() -> Analytics.OptInStatus {
			@Dependency(\.userDefaults) var userDefaults
			return Analytics.OptInStatus(rawValue: userDefaults.string(forKey: userDefaultsOptInKey) ?? "") ?? .optedIn
		}

		@Sendable func initialize() {
			@Dependency(\.bundle) var bundle
			@Dependency(TelemetryDeckClient.self) var telemetryDeck

			let telemetryDeckApiKey: String = {
				bundle.object(forInfoDictionaryKey: "TELEMETRY_DECK_API_KEY") as? String ?? ""
			}()

			let configuration = TelemetryManagerConfiguration(appID: telemetryDeckApiKey)
			if telemetryDeckApiKey.isEmpty {
				print("Analytics disabled")
				configuration.analyticsDisabled = true
			} else if getOptInStatus() == .optedOut {
				print("Analytics opted out")
				configuration.analyticsDisabled = true
			}

			telemetryDeck.initialize(with: configuration)
		}

		return Self(
			initialize: initialize,
			trackEvent: { event in
				@Dependency(TelemetryDeckClient.self) var telemetryDeck
				let payload = (event.payload ?? [:]).merging(await properties.value) { first, _ in first }
				telemetryDeck.send(event.name, with: payload)
			},
			setGlobalProperty: { key, value in
				await properties.withValue {
					if let value {
						$0[key] = value
					} else {
						$0[key] = nil
					}
				}
			},
			getOptInStatus: getOptInStatus,
			setOptInStatus: { newValue in
				@Dependency(TelemetryDeckClient.self) var telemetryDeck
				@Dependency(\.userDefaults) var userDefaults

				userDefaults.setString(forKey: userDefaultsOptInKey, to: newValue.rawValue)
				telemetryDeck.terminate()
				initialize()

				return getOptInStatus()
			}
		)
	}
}

@DependencyClient
struct TelemetryDeckClient: Sendable {
	var initialize: @Sendable (_ with: TelemetryManagerConfiguration) -> Void
	var send: @Sendable (String, _ with: [String: String]) -> Void
	var terminate: @Sendable () -> Void
}

extension TelemetryDeckClient: TestDependencyKey {
	static var testValue = Self()
}

extension TelemetryDeckClient: DependencyKey {
	static var liveValue = live()

	static func live() -> Self {
		Self(
			initialize: { configuration in TelemetryManager.initialize(with: configuration) },
			send: { name, payload in TelemetryManager.send(name, with: payload) },
			terminate: { TelemetryManager.terminate() }
		)
	}
}

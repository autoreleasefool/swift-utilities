import AnalyticsPackageServiceInterface
import BundlePackageServiceInterface
import Dependencies
import DependenciesMacros
import Foundation
import TelemetryDeck
import UserDefaultsPackageServiceInterface

extension AnalyticsService: DependencyKey {
	public static var liveValue: Self {
		let properties = LockIsolated<[String: String]>([:])
		let userDefaultsOptInKey = "telemetryDeckAnalyticsOptIn"

		@Sendable func getOptInStatus() -> Analytics.OptInStatus {
			@Dependency(\.userDefaults) var userDefaults
			return Analytics.OptInStatus(rawValue: userDefaults.string(forKey: userDefaultsOptInKey) ?? "") ?? .optedIn
		}

		@Sendable func initialize() {
			@Dependency(BundleService.self) var bundle
			@Dependency(TelemetryDeckClient.self) var telemetryDeck

			let telemetryDeckApiKey: String = {
				bundle.object(forInfoDictionaryKey: "TELEMETRY_DECK_API_KEY") as? String ?? ""
			}()

			let configuration = TelemetryDeck.Config(appID: telemetryDeckApiKey)
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
				let payload = (event.payload ?? [:]).merging(properties.value) { first, _ in first }
				telemetryDeck.send(event.name, with: payload)
			},
			setGlobalProperty: { key, value in
				properties.withValue {
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
	public static var testValue: Self { Self() }
}

extension TelemetryDeckClient: DependencyKey {
	static var liveValue: Self { live() }

	static func live() -> Self {
		Self(
			initialize: { configuration in TelemetryDeck.initialize(config: configuration) },
			send: { name, payload in TelemetryDeck.signal(name, parameters: payload) },
			terminate: { TelemetryDeck.terminate() }
		)
	}
}

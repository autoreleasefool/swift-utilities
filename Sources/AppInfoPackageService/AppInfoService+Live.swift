import AppInfoPackageServiceInterface
import BundlePackageServiceInterface
import Dependencies
import Foundation
import UserDefaultsPackageServiceInterface

extension AppInfoService: DependencyKey {
	public static var liveValue: Self {
		let initialized = ActorIsolated(false)

		@Sendable func getNumberOfSessions() -> Int {
			@Dependency(\.userDefaults) var userDefaults
			return userDefaults.int(forKey: .appSessions) ?? 0
		}

		@Sendable func getInstallDate() -> Date {
			@Dependency(\.userDefaults) var userDefaults
			return Date(timeIntervalSince1970: userDefaults.double(forKey: .installDate) ?? 0)
		}

		@Sendable func getAppVersion() -> String {
			@Dependency(\.bundle) var bundle
			return (bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "⚠️"
		}

		@Sendable func getBuildVersion() -> String {
			@Dependency(\.bundle) var bundle
			return (bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "⚠️"
		}

		return Self(
			initialize: {
				guard await !initialized.value else { return }
				await initialized.setValue(true)

				@Dependency(\.userDefaults) var userDefaults
				userDefaults.setInt(forKey: .appSessions, to: getNumberOfSessions() + 1)

				let installDate = getInstallDate()
				if installDate.timeIntervalSince1970 == 0 {
					@Dependency(\.date) var date
					userDefaults.setDouble(forKey: .installDate, to: date().timeIntervalSince1970)
				}
			},
			getNumberOfSessions: { getNumberOfSessions() },
			getInstallDate: { getInstallDate() },
			getAppVersion: { getAppVersion() },
			getBuildVersion: { getBuildVersion() },
			getFullAppVersion: { "\(getAppVersion()) (\(getBuildVersion()))" }
		)
	}
}

extension String {
	static let appSessions = "AppInfo.NumberOfSessions"
	static let installDate = "AppInfo.InstallDate"
}

import AppInfoPackageServiceInterface
import Dependencies
import Foundation
import StoreReviewPackageServiceInterface
import UserDefaultsPackageServiceInterface

extension StoreReviewService: DependencyKey {
	public static var liveValue: Self {
		Self(
			initialize: { numberOfSessions, minimumDaysSinceInstall, minimumDaysSinceLastRequest, canReviewMultipleTimes in
				@Dependency(\.userDefaults) var userDefaults

				userDefaults.setInt(forKey: .numberOfSessionsForReview, to: numberOfSessions)
				userDefaults.setInt(forKey: .minimumNumberOfDaysSinceInstallForReview, to: minimumDaysSinceInstall)
				userDefaults.setInt(forKey: .minimumNumberOfDaysSinceLastRequestForReview, to: minimumDaysSinceLastRequest)
				userDefaults.setBool(forKey: .canReviewVersionMultipleTimes, to: canReviewMultipleTimes)
			},
			shouldRequestReview: {
				@Dependency(\.appInfo) var appInfo
				@Dependency(\.userDefaults) var userDefaults

				let numberOfSessions = appInfo.getNumberOfSessions()
				let minimumNumberOfSessions = userDefaults.int(forKey: .numberOfSessionsForReview)
				guard let minimumNumberOfSessions, numberOfSessions >= minimumNumberOfSessions else {
					return false
				}

				@Dependency(\.date) var date
				@Dependency(\.calendar) var calendar

				let installDate = appInfo.getInstallDate()
				let daysSinceInstall = calendar.dateComponents([.day], from: installDate, to: date()).day
				let minimumDaysSinceInstall = userDefaults.int(forKey: .minimumNumberOfDaysSinceInstallForReview)
				guard let daysSinceInstall, let minimumDaysSinceInstall, daysSinceInstall >= minimumDaysSinceInstall else {
					return false
				}

				let lastRequestDate = userDefaults.double(forKey: .lastReviewRequestDate)
				if let lastRequestDate {
					let minimumDaysSinceLastRequest = userDefaults.int(forKey: .minimumNumberOfDaysSinceLastRequestForReview)
					let daysSinceLastRequest = calendar.dateComponents(
						[.day],
						from: Date(timeIntervalSince1970: lastRequestDate),
						to: date()
					).day
					guard let minimumDaysSinceLastRequest,
									let daysSinceLastRequest,
									daysSinceLastRequest >= minimumDaysSinceLastRequest
					else {
						return false
					}
				}

				let canReviewVersionMultipleTimes = userDefaults.bool(forKey: .canReviewVersionMultipleTimes)
				if let canReviewVersionMultipleTimes, !canReviewVersionMultipleTimes {
					let lastVersionReviewed = userDefaults.string(forKey: .lastReviewRequestVersion)
					if let lastVersionReviewed, lastVersionReviewed == appInfo.getFullAppVersion() {
						return false
					}
				}

				return true
			},
			didRequestReview: {
				@Dependency(\.appInfo) var appInfo
				@Dependency(\.date) var date
				@Dependency(\.userDefaults) var userDefaults

				userDefaults.setDouble(forKey: .lastReviewRequestDate, to: date().timeIntervalSince1970)
				userDefaults.setString(forKey: .lastReviewRequestVersion, to: appInfo.getFullAppVersion())
			}
		)
	}
}

extension String {
	static let numberOfSessionsForReview = "StoreReview.NumberOfSessions"
	static let minimumNumberOfDaysSinceInstallForReview = "StoreReview.DaysSinceInstall"
	static let minimumNumberOfDaysSinceLastRequestForReview = "StoreReview.DaysSinceLastRequest"
	static let canReviewVersionMultipleTimes = "StoreReview.CanReviewMultipleTimes"
	static let lastReviewRequestDate = "StoreReview.LastReviewRequestDate"
	static let lastReviewRequestVersion = "StoreReview.LastReviewRequestVersion"
}

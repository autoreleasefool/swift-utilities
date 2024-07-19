import AppInfoPackageServiceInterface
import Dependencies
@testable import StoreReviewPackageService
@testable import StoreReviewPackageServiceInterface
import UserDefaultsPackageServiceInterface
import XCTest

final class StoreReviewServiceTests: XCTestCase {
	@Dependency(\.storeReview) var storeReview

	// MARK: initialize

	func test_initialize_setsProperties() {
		let liveValue: StoreReviewService = .liveValue
		let cache = LockIsolated<[String: Sendable]>([:])

		withDependencies {
			$0.userDefaults.setInt = { @Sendable key, value in cache.withValue { $0[key] = value } }
			$0.userDefaults.setBool = { @Sendable key, value in cache.withValue { $0[key] = value } }
			$0.storeReview.initialize = liveValue.initialize
		} operation: {
			self.storeReview.initialize(
				numberOfSessions: 4,
				minimumDaysSinceInstall: 92,
				minimumDaysSinceLastRequest: 23,
				canReviewVersionMultipleTimes: true
			)
		}

		XCTAssertEqual(cache.keys.count, 4)
		XCTAssertEqual(cache.value[.canReviewVersionMultipleTimes] as? Bool, true)
		XCTAssertEqual(cache.value[.numberOfSessionsForReview] as? Int, 4)
		XCTAssertEqual(cache.value[.minimumNumberOfDaysSinceInstallForReview] as? Int, 92)
		XCTAssertEqual(cache.value[.minimumNumberOfDaysSinceLastRequestForReview] as? Int, 23)
	}

	// MARK: shouldRequestReview

	func test_shouldRequestReview_withRequirementsMet_returnsTrue() throws {
		let liveValue: StoreReviewService = .liveValue
		let cache = LockIsolated<[String: Sendable]>([
			.canReviewVersionMultipleTimes: false,
			.lastReviewRequestDate: 1.0,
			.lastReviewRequestVersion: "1.2.3 (92)",
			.numberOfSessionsForReview: 3,
			.minimumNumberOfDaysSinceInstallForReview: 1,
			.minimumNumberOfDaysSinceLastRequestForReview: 1,
		])

		let shouldRequestReview = try withDependencies {
			$0.date = .constant(Date(timeIntervalSince1970: 1_234_567_890))
			$0.calendar = .autoupdatingCurrent
			$0.appInfo.getFullAppVersion = { "1.2.4 (93)"}
			$0.appInfo.getNumberOfSessions = { 4 }
			$0.appInfo.getInstallDate = { Date(timeIntervalSince1970: 1) }
			$0.userDefaults.int = { @Sendable key in cache[key] as? Int }
			$0.userDefaults.string = { @Sendable key in cache[key] as? String }
			$0.userDefaults.bool = { @Sendable key in cache[key] as? Bool }
			$0.userDefaults.double = { @Sendable key in cache[key] as? Double }
			$0.storeReview.shouldRequestReview = liveValue.shouldRequestReview
		} operation: {
			try self.storeReview.shouldRequestReview()
		}

		XCTAssertTrue(shouldRequestReview)
	}

	func test_shouldRequestReview_withTooFewSessions_returnsFalse() throws {
		let liveValue: StoreReviewService = .liveValue
		let cache = LockIsolated<[String: Sendable]>([
			.canReviewVersionMultipleTimes: false,
			.lastReviewRequestDate: 1.0,
			.lastReviewRequestVersion: "1.2.3 (92)",
			.numberOfSessionsForReview: 3,
			.minimumNumberOfDaysSinceInstallForReview: 1,
			.minimumNumberOfDaysSinceLastRequestForReview: 1,
		])

		let shouldRequestReview = try withDependencies {
			$0.date = .constant(Date(timeIntervalSince1970: 1_234_567_890))
			$0.calendar = .autoupdatingCurrent
			$0.appInfo.getFullAppVersion = { "1.2.4 (93)"}
			$0.appInfo.getNumberOfSessions = { 2 }
			$0.appInfo.getInstallDate = { Date(timeIntervalSince1970: 1) }
			$0.userDefaults.int = { @Sendable key in cache[key] as? Int }
			$0.userDefaults.string = { @Sendable key in cache[key] as? String }
			$0.userDefaults.bool = { @Sendable key in cache[key] as? Bool }
			$0.userDefaults.double = { @Sendable key in cache[key] as? Double }
			$0.storeReview.shouldRequestReview = liveValue.shouldRequestReview
		} operation: {
			try self.storeReview.shouldRequestReview()
		}

		XCTAssertFalse(shouldRequestReview)
	}

	func test_shouldRequestReview_withTooFewDaysSinceInstall_returnsFalse() throws {
		let liveValue: StoreReviewService = .liveValue
		let cache = LockIsolated<[String: Sendable]>([
			.canReviewVersionMultipleTimes: false,
			.lastReviewRequestDate: 1.0,
			.lastReviewRequestVersion: "1.2.3 (92)",
			.numberOfSessionsForReview: 3,
			.minimumNumberOfDaysSinceInstallForReview: 1,
			.minimumNumberOfDaysSinceLastRequestForReview: 1,
		])

		let shouldRequestReview = try withDependencies {
			$0.date = .constant(Date(timeIntervalSince1970: 1_234_567_890))
			$0.calendar = .autoupdatingCurrent
			$0.appInfo.getFullAppVersion = { "1.2.4 (93)"}
			$0.appInfo.getNumberOfSessions = { 4 }
			$0.appInfo.getInstallDate = { Date(timeIntervalSince1970: 1_234_567_889) }
			$0.userDefaults.int = { @Sendable key in cache[key] as? Int }
			$0.userDefaults.string = { @Sendable key in cache[key] as? String }
			$0.userDefaults.bool = { @Sendable key in cache[key] as? Bool }
			$0.userDefaults.double = { @Sendable key in cache[key] as? Double }
			$0.storeReview.shouldRequestReview = liveValue.shouldRequestReview
		} operation: {
			try self.storeReview.shouldRequestReview()
		}

		XCTAssertFalse(shouldRequestReview)
	}

	func test_shouldRequestReview_withTooFewDaysSinceLastRequest_returnsFalse() throws {
		let liveValue: StoreReviewService = .liveValue
		let cache = LockIsolated<[String: Sendable]>([
			.canReviewVersionMultipleTimes: false,
			.lastReviewRequestDate: 1_234_567_889.0,
			.lastReviewRequestVersion: "1.2.3 (92)",
			.numberOfSessionsForReview: 3,
			.minimumNumberOfDaysSinceInstallForReview: 1,
			.minimumNumberOfDaysSinceLastRequestForReview: 1,
		])

		let shouldRequestReview = try withDependencies {
			$0.date = .constant(Date(timeIntervalSince1970: 1_234_567_890))
			$0.calendar = .autoupdatingCurrent
			$0.appInfo.getFullAppVersion = { "1.2.4 (93)"}
			$0.appInfo.getNumberOfSessions = { 4 }
			$0.appInfo.getInstallDate = { Date(timeIntervalSince1970: 1) }
			$0.userDefaults.int = { @Sendable key in cache[key] as? Int }
			$0.userDefaults.string = { @Sendable key in cache[key] as? String }
			$0.userDefaults.bool = { @Sendable key in cache[key] as? Bool }
			$0.userDefaults.double = { @Sendable key in cache[key] as? Double }
			$0.storeReview.shouldRequestReview = liveValue.shouldRequestReview
		} operation: {
			try self.storeReview.shouldRequestReview()
		}

		XCTAssertFalse(shouldRequestReview)
	}

	func test_shouldRequestReview_withReviewOfSameVersion_returnsFalse() throws {
		let liveValue: StoreReviewService = .liveValue
		let cache = LockIsolated<[String: Sendable]>([
			.canReviewVersionMultipleTimes: false,
			.lastReviewRequestDate: 1.0,
			.lastReviewRequestVersion: "1.2.3 (92)",
			.numberOfSessionsForReview: 3,
			.minimumNumberOfDaysSinceInstallForReview: 1,
			.minimumNumberOfDaysSinceLastRequestForReview: 1,
		])

		let shouldRequestReview = try withDependencies {
			$0.date = .constant(Date(timeIntervalSince1970: 1_234_567_890))
			$0.calendar = .autoupdatingCurrent
			$0.appInfo.getFullAppVersion = { "1.2.3 (92)"}
			$0.appInfo.getNumberOfSessions = { 4 }
			$0.appInfo.getInstallDate = { Date(timeIntervalSince1970: 1) }
			$0.userDefaults.int = { @Sendable key in cache[key] as? Int }
			$0.userDefaults.string = { @Sendable key in cache[key] as? String }
			$0.userDefaults.bool = { @Sendable key in cache[key] as? Bool }
			$0.userDefaults.double = { @Sendable key in cache[key] as? Double }
			$0.storeReview.shouldRequestReview = liveValue.shouldRequestReview
		} operation: {
			try self.storeReview.shouldRequestReview()
		}

		XCTAssertFalse(shouldRequestReview)
	}

	// MARK: didRequestReview

	func test_didRequestReview_setsProperties() {
		let liveValue: StoreReviewService = .liveValue
		let cache = LockIsolated<[String: Sendable]>([:])

		withDependencies {
			$0.date = .constant(Date(timeIntervalSince1970: 1_234_567_890))
			$0.appInfo.getFullAppVersion = { "1.2.3 (92)"}
			$0.userDefaults.setDouble = { @Sendable key, value in cache.withValue { $0[key] = value } }
			$0.userDefaults.setString = { @Sendable key, value in cache.withValue { $0[key] = value } }
			$0.storeReview.didRequestReview = liveValue.didRequestReview
		} operation: {
			self.storeReview.didRequestReview()
		}

		XCTAssertEqual(cache.keys.count, 2)
		XCTAssertEqual(cache.value[.lastReviewRequestDate] as? Double, 1_234_567_890)
		XCTAssertEqual(cache.value[.lastReviewRequestVersion] as? String, "1.2.3 (92)")
	}
}

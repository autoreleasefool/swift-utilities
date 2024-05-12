@testable import AppInfoService
@testable import AppInfoServiceInterface
import BundleServiceInterface
import Dependencies
import UserDefaultsServiceInterface
import XCTest

final class AppInfoServiceTests: XCTestCase {
	@Dependency(\.appInfo) var appInfo
	// MARK: - initialize

	func test_initialize_onlyInitializesOnce() async {
		let liveValue: AppInfoService = .live()
		let expectation = self.expectation(description: "update app session")
		expectation.assertForOverFulfill = true

		await withDependencies {
			$0.userDefaults.setInt = { @Sendable key, value in
				XCTAssertEqual(key, .appSessions)
				XCTAssertEqual(value, 1)
				expectation.fulfill()
			}
			$0.userDefaults.int = { @Sendable _ in nil }
			$0.userDefaults.double = { @Sendable _ in nil }
			$0.userDefaults.setDouble = { @Sendable _, _ in }
			$0.date = .constant(Date(timeIntervalSince1970: 0))
			$0.appInfo.initialize = liveValue.initialize
			$0.appInfo.getInstallDate = liveValue.getInstallDate
			$0.appInfo.getNumberOfSessions = liveValue.getNumberOfSessions
		} operation: {
			await self.appInfo.initialize()
			await self.appInfo.initialize()
		}

		await fulfillment(of: [expectation], timeout: 1)
	}

	func test_initialize_setsInstallDate() async {
		let liveValue: AppInfoService = .live()
		let expectation = self.expectation(description: "set install date")

		await withDependencies {
			$0.userDefaults.setInt = { @Sendable _, _ in }
			$0.userDefaults.int = { @Sendable _ in nil }
			$0.userDefaults.double = { @Sendable _ in nil }
			$0.userDefaults.setDouble = { @Sendable key, value in
				XCTAssertEqual(key, .installDate)
				XCTAssertEqual(value, 1_234_567_890)
				expectation.fulfill()
			}
			$0.date = .constant(Date(timeIntervalSince1970: 1_234_567_890))
			$0.appInfo.initialize = liveValue.initialize
			$0.appInfo.getInstallDate = liveValue.getInstallDate
			$0.appInfo.getNumberOfSessions = liveValue.getNumberOfSessions
		} operation: {
			await self.appInfo.initialize()
		}

		await fulfillment(of: [expectation], timeout: 1)
	}

	func test_initialize_doesNotOverrideInstallDate() async {
		let liveValue: AppInfoService = .live()
		let expectation = self.expectation(description: "set install date")
		expectation.isInverted = true

		await withDependencies {
			$0.userDefaults.setInt = { @Sendable _, _ in }
			$0.userDefaults.int = { @Sendable _ in nil }
			$0.userDefaults.double = { @Sendable _ in 1_234_567_890 }
			$0.userDefaults.setDouble = { @Sendable _, _ in
				expectation.fulfill()
			}
			$0.date = .constant(Date(timeIntervalSince1970: 1_234_567_891))
			$0.appInfo.initialize = liveValue.initialize
			$0.appInfo.getInstallDate = liveValue.getInstallDate
			$0.appInfo.getNumberOfSessions = liveValue.getNumberOfSessions
		} operation: {
			await self.appInfo.initialize()
		}

		await fulfillment(of: [expectation], timeout: 1)
	}

	func test_initialize_updatesSessionCount() async {
		let liveValue: AppInfoService = .live()
		let expectation = self.expectation(description: "update app session")

		await withDependencies {
			$0.userDefaults.setInt = { @Sendable key, value in
				XCTAssertEqual(key, .appSessions)
				XCTAssertEqual(value, 93)
				expectation.fulfill()
			}
			$0.userDefaults.int = { @Sendable _ in 92 }
			$0.userDefaults.double = { @Sendable _ in nil }
			$0.userDefaults.setDouble = { @Sendable _, _ in }
			$0.date = .constant(Date(timeIntervalSince1970: 0))
			$0.appInfo.initialize = liveValue.initialize
			$0.appInfo.getInstallDate = liveValue.getInstallDate
			$0.appInfo.getNumberOfSessions = liveValue.getNumberOfSessions
		} operation: {
			await self.appInfo.initialize()
		}

		await fulfillment(of: [expectation], timeout: 1)
	}

	// MARK: - getNumberOfSessions

	func test_getNumberOfSessions_returnsZeroByDefault() {
		let liveValue: AppInfoService = .live()

		let numberOfSessions = withDependencies {
			$0.userDefaults.int = { @Sendable _ in nil }
			$0.appInfo.getNumberOfSessions = liveValue.getNumberOfSessions
		} operation: {
			self.appInfo.getNumberOfSessions()
		}

		XCTAssertEqual(numberOfSessions, 0)
	}

	func test_getNumberOfSessions_returnsValue() {
		let liveValue: AppInfoService = .live()

		let numberOfSessions = withDependencies {
			$0.userDefaults.int = { @Sendable _ in 92 }
			$0.appInfo.getNumberOfSessions = liveValue.getNumberOfSessions
		} operation: {
			self.appInfo.getNumberOfSessions()
		}

		XCTAssertEqual(numberOfSessions, 92)
	}

	// MARK: - getInstallDate

	func test_getInstallDate_returnsZeroByDefault() {
		let liveValue: AppInfoService = .live()

		let installDate = withDependencies {
			$0.userDefaults.double = { @Sendable _ in nil }
			$0.appInfo.getInstallDate = liveValue.getInstallDate
		} operation: {
			self.appInfo.getInstallDate()
		}

		XCTAssertEqual(installDate, Date(timeIntervalSince1970: 0))
	}

	func test_getInstallDate_returnsValue() {
		let liveValue: AppInfoService = .live()

		let installDate = withDependencies {
			$0.userDefaults.double = { @Sendable _ in 1_234_567_890 }
			$0.appInfo.getInstallDate = liveValue.getInstallDate
		} operation: {
			self.appInfo.getInstallDate()
		}

		XCTAssertEqual(installDate, Date(timeIntervalSince1970: 1_234_567_890))
	}

	// MARK: - getAppVersion

	func test_getAppVersion_returnsValue() {
		let liveValue: AppInfoService = .live()

		let appVersion = withDependencies {
			$0.bundle.object = { @Sendable _ in "1.2.3" }
			$0.appInfo.getAppVersion = liveValue.getAppVersion
		} operation: {
			self.appInfo.getAppVersion()
		}

		XCTAssertEqual(appVersion, "1.2.3")
	}

	// MARK: - getBuildVersion

	func test_getBuildVersion_returnsValue() {
		let liveValue: AppInfoService = .live()

		let buildVersion = withDependencies {
			$0.bundle.object = { @Sendable _ in "92" }
			$0.appInfo.getBuildVersion = liveValue.getBuildVersion
		} operation: {
			self.appInfo.getBuildVersion()
		}

		XCTAssertEqual(buildVersion, "92")
	}

	// MARK: - getFullAppVersion

	func test_getFullAppVersion_returnsValue() {
		let liveValue: AppInfoService = .live()

		let fullAppVersion = withDependencies {
			$0.bundle.object = { @Sendable key in
				if key == "CFBundleVersion" {
					return "92"
				} else if key == "CFBundleShortVersionString" {
					return "1.2.3"
				} else {
					XCTFail("Unexpected key \(key)")
					return nil
				}
			}
			$0.appInfo.getFullAppVersion = liveValue.getFullAppVersion
		} operation: {
			self.appInfo.getFullAppVersion()
		}

		XCTAssertEqual(fullAppVersion, "1.2.3 (92)")
	}
}

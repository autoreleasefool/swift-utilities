@testable import AnalyticsPackageService
@testable import AnalyticsPackageServiceInterface
import Dependencies
import XCTest

final class AnalyticsServiceTests: XCTestCase {
	@Dependency(\.analytics) var analytics

	func test_getOptInStatus_isOptedInByDefault() {
		let liveValue: AnalyticsService = .liveValue

		let optInStatus = withDependencies {
			$0.analytics.getOptInStatus = liveValue.getOptInStatus
		} operation: {
			self.analytics.getOptInStatus()
		}

		XCTAssertEqual(optInStatus, .optedIn)
	}

	func test_setOptInStatus_updatedStatus() async throws {
		let liveValue: AnalyticsService = .liveValue

		let firstUpdate = try await withDependencies {
			$0.analytics.getOptInStatus = liveValue.getOptInStatus
			$0.analytics.setOptInStatus = liveValue.setOptInStatus
		} operation: {
			try await self.analytics.setOptInStatus(.optedIn)
		}

		XCTAssertEqual(firstUpdate, .optedIn)

		let secondUpdate = try await withDependencies {
			$0.analytics.getOptInStatus = liveValue.getOptInStatus
			$0.analytics.setOptInStatus = liveValue.setOptInStatus
		} operation: {
			try await self.analytics.setOptInStatus(.optedOut)
		}

		XCTAssertEqual(secondUpdate, .optedOut)
	}
}

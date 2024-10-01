@testable import AnalyticsPackageService
@testable import AnalyticsPackageServiceInterface
import Dependencies
import Testing

@Suite("Analytics Service")
struct AnalyticsServiceTests {

	@Suite("Get opt in status")
	struct GetOptInStatus {
		@Dependency(\.analytics) var analytics

		@Test func isOptedInByDefault() {
			let optInStatus = withDependencies {
				$0.analytics.getOptInStatus = AnalyticsService.liveValue.getOptInStatus
			} operation: {
				self.analytics.getOptInStatus()
			}

			#expect(optInStatus == .optedIn)
		}
	}

	@Suite("Set opt in status")
	struct SetOptInStatus {
		@Dependency(\.analytics) var analytics

		@Test func updatesStatus() async throws {
			let liveValue: AnalyticsService = .liveValue

			let firstUpdate = try await withDependencies {
				$0.analytics.getOptInStatus = liveValue.getOptInStatus
				$0.analytics.setOptInStatus = liveValue.setOptInStatus
			} operation: {
				try await self.analytics.setOptInStatus(.optedIn)
			}

			#expect(firstUpdate == .optedIn)

			let secondUpdate = try await withDependencies {
				$0.analytics.getOptInStatus = liveValue.getOptInStatus
				$0.analytics.setOptInStatus = liveValue.setOptInStatus
			} operation: {
				try await self.analytics.setOptInStatus(.optedOut)
			}

			#expect(secondUpdate == .optedOut)
		}
	}
}

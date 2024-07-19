import Dependencies
import DependenciesMacros

@DependencyClient
public struct StoreReviewService: Sendable {
	public var initialize: @Sendable (
		_ numberOfSessions: Int,
		_ minimumDaysSinceInstall: Int,
		_ minimumDaysSinceLastRequest: Int,
		_ canReviewVersionMultipleTimes: Bool
	) -> Void
	public var shouldRequestReview: @Sendable () throws -> Bool
	public var didRequestReview: @Sendable () -> Void
}

extension StoreReviewService: TestDependencyKey {
	public static var testValue: Self { Self() }
}

extension DependencyValues {
	public var storeReview: StoreReviewService {
		get { self[StoreReviewService.self] }
		set { self[StoreReviewService.self] = newValue }
	}
}

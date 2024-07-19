import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct AnalyticsService: Sendable {
	public var initialize: @Sendable () throws -> Void
	public var trackEvent: @Sendable (TrackableEvent) async throws -> Void
	public var setGlobalProperty: @Sendable (_ key: String, _ value: String?) async throws -> Void
	public var getOptInStatus: @Sendable () -> Analytics.OptInStatus = {
		XCTFail("\(Self.self).getOptInStatus"); return .optedOut
	}
	public var setOptInStatus: @Sendable (Analytics.OptInStatus) async throws -> Analytics.OptInStatus
}

extension AnalyticsService: TestDependencyKey {
	public static var testValue: Self { Self() }
}

extension DependencyValues {
	public var analytics: AnalyticsService {
		get { self[AnalyticsService.self] }
		set { self[AnalyticsService.self] = newValue }
	}
}

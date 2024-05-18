import Dependencies
import DependenciesMacros
import FeatureFlagsPackageLibrary

@DependencyClient
public struct FeatureFlagsService: Sendable {
	public var initialize: @Sendable (_ registeringFeatureFlags: [FeatureFlag]) -> Void
	public var isEnabled: @Sendable (FeatureFlag) throws -> Bool
	public var allEnabled: @Sendable ([FeatureFlag]) throws -> Bool
	public var observe: @Sendable (_ flag: FeatureFlag) throws -> AsyncStream<Bool>
	public var observeAll: @Sendable (_ flags: [FeatureFlag]) throws -> AsyncStream<[FeatureFlag: Bool]>
	public var setEnabled: @Sendable (FeatureFlag, Bool?) -> Void
	public var resetOverrides: @Sendable () -> Void
}

extension FeatureFlagsService: TestDependencyKey {
	public static var testValue = Self()
}

extension DependencyValues {
	public var featureFlags: FeatureFlagsService {
		get { self[FeatureFlagsService.self] }
		set { self[FeatureFlagsService.self] = newValue }
	}
}

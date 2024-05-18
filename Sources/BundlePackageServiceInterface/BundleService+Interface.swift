import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct BundleService: Sendable {
	public var appStoreReceiptURL: @Sendable () -> URL?
	public var object: @Sendable (_ forInfoDictionaryKey: String) -> Any?
	public var infoDictionary: @Sendable () -> [String: Any]?
}

extension BundleService: TestDependencyKey {
	public static var testValue = Self()
}

extension DependencyValues {
	public var bundle: BundleService {
		get { self[BundleService.self] }
		set { self[BundleService.self] = newValue }
	}
}

import BundleServiceInterface
import Dependencies
import Foundation

extension BundleService: DependencyKey {
	public static func create(withBundle bundle: Bundle) -> Self {
		Self(
			appStoreReceiptURL: { bundle.appStoreReceiptURL },
			object: { key in bundle.object(forInfoDictionaryKey: key) },
			infoDictionary: { bundle.infoDictionary }
		)
	}

	public static var liveValue: Self { create(withBundle: .main) }
}

import BundlePackageServiceInterface
import Dependencies
import FeatureFlagsPackageLibrary
import Foundation

extension FeatureFlag {
	public var isEnabled: Bool {
		#if DEBUG
		stage >= .development
		#else
		@Dependency(\.bundle) var bundle
		let isTestFlight = bundle.appStoreReceiptURL()?.lastPathComponent == "sandboxReceipt"
		if isTestFlight {
			return stage >= .test
		} else {
			return stage >= .release
		}
		#endif
	}
}

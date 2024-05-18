import SnapshotTesting
import SwiftUI
@testable import SwiftUIExtensionsPackageLibrary
import XCTest

final class ConditionalViewModifierTests: XCTestCase {
	func testConditionalViewModifierSnapshot() throws {
#if canImport(UIKit)
		let conditionalView = Group {
			Text("With Background")
				.if(true) {
					$0.background(Rectangle().fill(.red))
				}

			Text("Without Background")
				.if(false) {
					$0.background(Rectangle().fill(.red))
				}
		}

		let vc = UIHostingController(rootView: conditionalView)
		vc.view.frame = UIScreen.main.bounds

		assertSnapshot(matching: vc, as: .image(on: .iPhoneSe))
#else
		try XCTSkipIf(true)
#endif
	}

}

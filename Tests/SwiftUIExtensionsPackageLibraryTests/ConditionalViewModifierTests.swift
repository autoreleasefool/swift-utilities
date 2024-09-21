import SnapshotTesting
import SwiftUI
@testable import SwiftUIExtensionsPackageLibrary
import Testing

struct ConditionalViewModifierTests {
	@Test @MainActor func snapshot() throws {
#if os(iOS)
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
		.frame(width: 428)

		assertSnapshot(of: conditionalView, as: .image)
#else
		try XCTSkipIf(true)
#endif
	}
}

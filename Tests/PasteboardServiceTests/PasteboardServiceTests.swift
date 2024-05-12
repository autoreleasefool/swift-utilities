import Dependencies
@testable import PasteboardService
@testable import PasteboardServiceInterface
import XCTest

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class PasteboardServiceTests: XCTestCase {
	@Dependency(\.pasteboard) var pasteboard

	func test_copyToClipboard_copiesString() async throws {
		#if canImport(UIKit)
		try XCTSkipIf(true, "Skipped because pasting on iOS requires manual intervention")
		#endif

		let liveValue: PasteboardService = .liveValue

		let stringToCopy = "Copied to clipboard"
		try await withDependencies {
			$0.pasteboard.copyToClipboard = liveValue.copyToClipboard
		} operation: {
			try await self.pasteboard.copyToClipboard(stringToCopy)
		}

		#if canImport(AppKit)
		XCTAssertEqual(NSPasteboard.general.string(forType: .string), stringToCopy)
		#elseif canImport(UIKit)
		XCTAssertEqual(UIPasteboard.general.string, stringToCopy)
		#endif
	}
}

@testable import ExtensionsLibrary
import XCTest

final class CaseIterableExtensionsTests: XCTestCase {
	func test_next_returnsNext() {
		let first = TestEnum.first
		XCTAssertEqual(first.next, .second)
	}

	func test_next_whenLastElement_returnsFirstElement() {
		let last = TestEnum.third
		XCTAssertEqual(last.next, .first)
	}

	func test_toNext_setsNextElement() {
		var first = TestEnum.first
		first.toNext()
		XCTAssertEqual(first, .second)
	}
}

enum TestEnum: CaseIterable {
	case first
	case second
	case third
}

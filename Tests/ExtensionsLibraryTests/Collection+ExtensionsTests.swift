@testable import ExtensionsLibrary
import XCTest

final class CollectionExtensionsTests: XCTestCase {

	// MARK: - toggle

	func test_toggle_whenItemInSet_removesItem() {
		var items: Set<String> = ["first", "second"]
		items.toggle("second")
		XCTAssertEqual(items, ["first"])
	}

	func test_toggle_whenItemNotInSet_addsItem() {
		var items: Set<String> = ["first", "second"]
		items.toggle("third")
		XCTAssertEqual(items, ["first", "second", "third"])
	}

	func test_toggleToContain_whenItemInSet_andToContain_doesNothing() {
		var items: Set<String> = ["first", "second"]
		items.toggle("second", toContain: true)
		XCTAssertEqual(items, ["first", "second"])
	}

	func test_toggleToContain_whenItemInSet_andNotToContain_removesItem() {
		var items: Set<String> = ["first", "second"]
		items.toggle("second", toContain: false)
		XCTAssertEqual(items, ["first"])
	}

	func test_toggleToContain_whenItemNotInSet_andToContain_insertsItem() {
		var items: Set<String> = ["first", "second"]
		items.toggle("third", toContain: true)
		XCTAssertEqual(items, ["first", "second", "third"])
	}

	func test_toggleToContain_whenItemNotInSet_andNotToContain_doesNothing() {
		var items: Set<String> = ["first", "second"]
		items.toggle("third", toContain: false)
		XCTAssertEqual(items, ["first", "second"])
	}

	// MARK: - findDuplicates

	func test_findDuplicates_whenSetHasNoDuplicates_returnsNothing() {
		let items = ["first", "second"]
		let duplicates = items.findDuplicates()
		XCTAssertEqual(duplicates, [])
	}

	func test_findDuplicates_whenSetHasOneDuplicate_returnsDuplicate() {
		let items = ["first", "second", "first"]
		let duplicates = items.findDuplicates()
		XCTAssertEqual(duplicates, ["first"])
	}

	func test_findDuplicates_whenSetHasManyDuplicates_returnsDuplicates() {
		let items = ["first", "second", "first", "third", "second", "first"]
		let duplicates = items.findDuplicates()
		XCTAssertEqual(duplicates, ["first", "second"])
	}
}

@testable import ExtensionsPackageLibrary
import XCTest

final class ArrayExtensionsTests: XCTestCase {
	func test_sortWithNoIds() {
		let id0 = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
		let id1 = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
		let id2 = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!

		let sortables = [
			Sortable(id: id0),
			Sortable(id: id2),
			Sortable(id: id1),
		]

		XCTAssertEqual(sortables, sortables.sortBy(ids: []))
	}

	func test_sortsAllElements() {
		let id0 = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
		let id1 = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
		let id2 = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!

		let sortables = [
			Sortable(id: id0),
			Sortable(id: id2),
			Sortable(id: id1),
		]

		XCTAssertEqual([
			Sortable(id: id2),
			Sortable(id: id1),
			Sortable(id: id0),
		], sortables.sortBy(ids: [id2, id1, id0]))
	}

	func test_sortsElementsToFront() {
		let id0 = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
		let id1 = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
		let id2 = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!

		let sortables = [
			Sortable(id: id0),
			Sortable(id: id2),
			Sortable(id: id1),
		]

		XCTAssertEqual([
			Sortable(id: id1),
			Sortable(id: id0),
			Sortable(id: id2),
		], sortables.sortBy(ids: [id1]))
	}
}

struct Sortable: Equatable, Identifiable {
	let id: UUID
}

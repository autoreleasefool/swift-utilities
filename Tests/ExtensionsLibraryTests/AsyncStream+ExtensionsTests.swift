import Dependencies
@testable import ExtensionsLibrary
import XCTest

final class AsyncStreamExtensionsTests: XCTestCase {

	// MARK: - sort

	func test_sortByIds_sortsItems() async {
		let (itemStream, itemContinuation) = AsyncStream<[Item]>.makeStream()
		let (idStream, idContinuation) = AsyncStream<[UUID]>.makeStream()

		let sortedStream = sort(itemStream, byIds: idStream)
		var iterator = sortedStream.makeAsyncIterator()

		itemContinuation.yield([Item(id: UUID(0)), Item(id: UUID(1)), Item(id: UUID(2))])
		idContinuation.yield([UUID(1), UUID(0), UUID(2)])

		var sorted = await iterator.next()
		XCTAssertEqual(
			sorted,
			[
				Item(id: UUID(1)),
				Item(id: UUID(0)),
				Item(id: UUID(2)),
			]
		)

		idContinuation.yield([UUID(0), UUID(2)])
		sorted = await iterator.next()
		XCTAssertEqual(
			sorted,
			[
				Item(id: UUID(0)),
				Item(id: UUID(2)),
				Item(id: UUID(1)),
			]
		)
	}

	func test_sortByIds_sortsItems_throwing() async throws {
		let (itemStream, itemContinuation) = AsyncThrowingStream<[Item], Error>.makeStream()
		let (idStream, idContinuation) = AsyncStream<[UUID]>.makeStream()

		let sortedStream = sort(itemStream, byIds: idStream)
		var iterator = sortedStream.makeAsyncIterator()

		itemContinuation.yield([Item(id: UUID(0)), Item(id: UUID(1)), Item(id: UUID(2))])
		idContinuation.yield([UUID(1), UUID(0), UUID(2)])

		var sorted = try await iterator.next()
		XCTAssertEqual(
			sorted,
			[
				Item(id: UUID(1)),
				Item(id: UUID(0)),
				Item(id: UUID(2)),
			]
		)

		idContinuation.yield([UUID(0), UUID(2)])
		sorted = try await iterator.next()
		XCTAssertEqual(
			sorted,
			[
				Item(id: UUID(0)),
				Item(id: UUID(2)),
				Item(id: UUID(1)),
			]
		)
	}

	// MARK: - prefix

	func test_prefix_returnsArrayPrefix() async {
		let (itemStream, itemContinuation) = AsyncStream<[Item]>.makeStream()

		let prefixedStream = prefix(itemStream, ofSize: 2)
		var iterator = prefixedStream.makeAsyncIterator()

		itemContinuation.yield([Item(id: UUID(0)), Item(id: UUID(1)), Item(id: UUID(2))])

		var prefix = await iterator.next()
		XCTAssertEqual(
			prefix,
			[
				Item(id: UUID(0)),
				Item(id: UUID(1)),
			]
		)
	}

	func test_prefix_returnsArrayPrefix_throwing() async throws {
		let (itemStream, itemContinuation) = AsyncThrowingStream<[Item], Error>.makeStream()

		let prefixedStream = prefix(itemStream, ofSize: 2)
		var iterator = prefixedStream.makeAsyncIterator()

		itemContinuation.yield([Item(id: UUID(0)), Item(id: UUID(1)), Item(id: UUID(2))])

		var prefix = try await iterator.next()
		XCTAssertEqual(
			prefix,
			[
				Item(id: UUID(0)),
				Item(id: UUID(1)),
			]
		)
	}
}

struct Item: Identifiable, Equatable {
	let id: UUID
}

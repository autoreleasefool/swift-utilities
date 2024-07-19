import AsyncAlgorithms
import ConcurrencyExtras
import Foundation

public func sort<T: Identifiable & Sendable>(
	_ itemsStream: AsyncStream<[T]>,
	byIds idsStream: AsyncStream<[UUID]>
) -> AsyncStream<[T]> where T.ID == UUID {
	combineLatest(itemsStream, idsStream)
		.map { items, ids in items.sortBy(ids: ids) }
		.eraseToStream()
}

public func sort<T: Identifiable & Sendable>(
	_ itemsStream: AsyncThrowingStream<[T], Error>,
	byIds idsStream: AsyncStream<[UUID]>
) -> AsyncThrowingStream<[T], Error> where T.ID == UUID {
	combineLatest(itemsStream, idsStream)
		.map { items, ids in items.sortBy(ids: ids) }
		.eraseToThrowingStream()
}

public func `prefix`<T>(
	_ itemsStream: AsyncStream<[T]>,
	ofSize: Int
) -> AsyncStream<[T]> {
	itemsStream
		.map { Array($0.prefix(ofSize)) }
		.eraseToStream()
}

public func `prefix`<T>(
	_ itemsStream: AsyncThrowingStream<[T], Error>,
	ofSize: Int
) -> AsyncThrowingStream<[T], Error> {
	itemsStream
		.map { Array($0.prefix(ofSize)) }
		.eraseToThrowingStream()
}

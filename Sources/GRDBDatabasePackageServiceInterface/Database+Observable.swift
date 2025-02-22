import ConcurrencyExtras
import GRDB

extension DatabaseReader {
	public func observe<Model: Sendable>(
			_ fetch: @escaping @Sendable (Database) throws -> [Model]
		) -> AsyncThrowingStream<[Model], Error> {
			ValueObservation
				.tracking(fetch)
				.values(in: self)
				.eraseToThrowingStream()
		}

	public func observeOne<Model: Sendable>(
			_ fetch: @escaping @Sendable (Database) throws -> Model?
	) -> AsyncThrowingStream<Model, Error> {
		AsyncThrowingStream { continuation in
			let task = Task {
				do {
					let observation = ValueObservation.tracking(fetch)

					for try await value in observation.values(in: self) {
						if let value {
							continuation.yield(value)
						} else {
							continuation.finish()
							break
						}
					}
				} catch {
					continuation.finish(throwing: error)
				}
			}
			continuation.onTermination = { _ in task.cancel() }
		}
	}
}

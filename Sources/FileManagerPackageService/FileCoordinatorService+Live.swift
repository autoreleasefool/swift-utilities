import Dependencies
import FileManagerPackageServiceInterface
import Foundation

private actor FileCoordinator {
	let coordinator = NSFileCoordinator()

	func read(
		itemAt url: URL,
		options: NSFileCoordinator.ReadingOptions,
		accessor: @Sendable (URL) throws -> Void
	) throws {
		var coordinatorError: NSError?
		var readError: Error?

		coordinator.coordinate(readingItemAt: url, options: options, error: &coordinatorError) { url in
			do {
				try accessor(url)
			} catch {
				readError = error
			}
		}

		if let readError {
			throw readError
		}

		if let coordinatorError {
			throw coordinatorError
		}
	}

	func write(
		itemAt url: URL,
		options: NSFileCoordinator.WritingOptions,
		accessor: @Sendable (URL) throws -> Void
	) throws {
		var coordinatorError: NSError?
		var writeError: Error?

		coordinator.coordinate(writingItemAt: url, options: options, error: &coordinatorError) { url in
			do {
				try accessor(url)
			} catch {
				writeError = error
			}
		}

		if let writeError {
			throw writeError
		}

		if let coordinatorError {
			throw coordinatorError
		}
	}
}

extension FileCoordinatorService: DependencyKey {
	public static var liveValue: Self {
		let coordinators = LockIsolated<[FileCoordinatorID: FileCoordinator]>([:])

		return Self(
			createCoordinator: {
				@Dependency(\.uuid) var uuid
				let id = uuid()
				coordinators.withValue { $0[id] = FileCoordinator() }
				return id
			},
			discardCoordinator: { id in
				coordinators.withValue { $0[id] = nil }
			},
			read: { url, id, options, accessor in
				guard let coordinator = coordinators.value[id] else {
					throw FileCoordinatorServiceError.coordinatorDoesNotExist
				}

				try await coordinator.read(itemAt: url, options: options, accessor: accessor)
			},
			write: { url, id, options, accessor in
				guard let coordinator = coordinators.value[id] else {
					throw FileCoordinatorServiceError.coordinatorDoesNotExist
				}

				try await coordinator.write(itemAt: url, options: options, accessor: accessor)
			}
		)
	}
}

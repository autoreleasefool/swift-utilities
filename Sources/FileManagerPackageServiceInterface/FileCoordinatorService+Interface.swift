import Dependencies
import DependenciesMacros
import Foundation

public typealias FileCoordinatorID = UUID

public enum FileCoordinatorServiceError: Error {
	case coordinatorDoesNotExist
}

@DependencyClient
public struct FileCoordinatorService: Sendable {
	public var createCoordinator: @Sendable () -> FileCoordinatorID = {
		unimplemented("\(Self.self).createCoordinator", placeholder: UUID())
	}
	public var discardCoordinator: @Sendable (FileCoordinatorID) -> Void
	public var read: @Sendable (
		_ itemAt: URL,
		_ withCoordinator: FileCoordinatorID,
		_ options: NSFileCoordinator.ReadingOptions,
		_ accessor: @Sendable (URL) throws -> Void
	) async throws -> Void
	public var write: @Sendable (
		_ itemAt: URL,
		_ withCoordinator: FileCoordinatorID,
		_ options: NSFileCoordinator.WritingOptions,
		_ accessor: @Sendable (URL) throws -> Void
	) async throws -> Void
}

extension FileCoordinatorService: TestDependencyKey {
	public static var testValue: Self { Self() }
}

extension DependencyValues {
	public var fileCoordinator: FileCoordinatorService {
		get { self[FileCoordinatorService.self] }
		set { self[FileCoordinatorService.self] = newValue }
	}
}

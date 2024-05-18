import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct FileManagerService {
	public var getFileContents: @Sendable (URL) throws -> Data
	public var getUserDirectory: @Sendable () throws -> URL
	public var getTemporaryDirectory: @Sendable () throws -> URL
	public var createDirectory: @Sendable (URL) throws -> Void
	public var remove: @Sendable (URL) throws -> Void
	public var exists: @Sendable (URL) throws -> Bool
}

extension FileManagerService: TestDependencyKey {
	public static var testValue = Self()
}

extension DependencyValues {
	public var fileManager: FileManagerService {
		get { self[FileManagerService.self] }
		set { self[FileManagerService.self] = newValue }
	}
}

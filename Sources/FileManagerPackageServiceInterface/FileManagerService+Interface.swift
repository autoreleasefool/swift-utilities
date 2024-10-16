import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct FileManagerService: Sendable {
	public var attributesOfItem: @Sendable (_ atPath: String) throws -> [FileAttributeKey: Any]
	public var getFileContents: @Sendable (URL) throws -> Data
	public var getUserDirectory: @Sendable () throws -> URL
	public var getTemporaryDirectory: @Sendable () throws -> URL
	public var createDirectory: @Sendable (URL) throws -> Void
	public var contentsOfDirectory: @Sendable (
		_ at: URL,
		_ includingPropertiesForKeys: [URLResourceKey]?,
		_ options: FileManager.DirectoryEnumerationOptions
	) throws -> [URL]
	public var urlForUbiquityContainerIdentifier: @Sendable (_: String?) -> URL?
	public var ubiquityIdentityToken: @Sendable () -> (any NSCoding & NSCopying & NSObjectProtocol)?
	public var copyItem: @Sendable (_ at: URL, _ to: URL) throws -> Void
	public var moveItem: @Sendable (_ at: URL, _ to: URL) throws -> Void
	public var remove: @Sendable (URL) throws -> Void
	public var exists: @Sendable (URL) throws -> Bool

	@Sendable public func contentsOfDirectory(at: URL) throws -> [URL] {
		try self.contentsOfDirectory(at: at, includingPropertiesForKeys: nil, options: [])
	}
}

extension FileManagerService: TestDependencyKey {
	public static var testValue: Self { Self() }
}

extension DependencyValues {
	public var fileManager: FileManagerService {
		get { self[FileManagerService.self] }
		set { self[FileManagerService.self] = newValue }
	}
}

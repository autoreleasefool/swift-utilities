import Dependencies
import FileManagerServiceInterface
import Foundation

extension FileManagerService: DependencyKey {
	public static var liveValue = live()

	static func live() -> Self {
		@Sendable func getTemporaryDirectory() -> URL {
			FileManager.default.temporaryDirectory
		}

		return Self(
			getFileContents: { url in
				try Data(contentsOf: url)
			},
			getUserDirectory: {
				try FileManager.default
					.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
			},
			getTemporaryDirectory: getTemporaryDirectory,
			createDirectory: { url in
				try FileManager.default
					.createDirectory(at: url, withIntermediateDirectories: true)
			},
			remove: { url in
				try FileManager.default
					.removeItem(at: url)
			},
			exists: { url in
				FileManager.default
					.fileExists(atPath: url.path())
			}
		)
	}
}

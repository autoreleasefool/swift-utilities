import Dependencies
import FileManagerPackageServiceInterface
import Foundation

extension FileManagerService: DependencyKey {
	public static var liveValue: Self {
		return Self(
			attributesOfItem: { path in
				try FileManager.default.attributesOfItem(atPath: path)
			},
			getFileContents: { url in
				try Data(contentsOf: url)
			},
			getUserDirectory: {
				try FileManager.default
					.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
			},
			getTemporaryDirectory: {
				FileManager.default.temporaryDirectory
			},
			createDirectory: { url in
				try FileManager.default
					.createDirectory(at: url, withIntermediateDirectories: true)
			},
			contentsOfDirectory: { url in
				try FileManager.default
					.contentsOfDirectory(at: url, includingPropertiesForKeys: [], options: [])
			},
			urlForUbiquityContainerIdentifier: { identifier in
				FileManager.default.url(forUbiquityContainerIdentifier: identifier)
			},
			copyItem: { at, to in
				try FileManager.default
					.copyItem(at: at, to: to)
			},
			moveItem: { at, to in
				try FileManager.default
					.moveItem(at: at, to: to)
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

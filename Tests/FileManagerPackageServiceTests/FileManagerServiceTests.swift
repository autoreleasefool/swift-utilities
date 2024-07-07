import Dependencies
@testable import FileManagerPackageService
@testable import FileManagerPackageServiceInterface
import XCTest

final class FileManagerServiceTests: XCTestCase {
	@Dependency(\.fileManager) private var fileManager

	override func tearDownWithError() throws {
		try? FileManager.default.removeItem(at: try Self.getTempFolder())
		try super.tearDownWithError()
	}

	private static func getTempFolder() throws -> URL {
		try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
			.appendingPathComponent("approach-tmp")
	}

	// MARK: - getFileContents

	func test_getFileContents() throws {
		let liveValue: FileManagerService = .liveValue
		let originalContents = "file contents"
		let filePath = try Self.getTempFolder().appendingPathComponent("temp.txt")
		try FileManager.default.createDirectory(at: try Self.getTempFolder(), withIntermediateDirectories: true)
		let originalData = Data(originalContents.utf8)
		try originalData.write(to: filePath)

		let readData = try withDependencies {
			$0.fileManager.getFileContents = liveValue.getFileContents
		} operation: {
			try fileManager.getFileContents(filePath)
		}

		let readContents = String(data: readData, encoding: .utf8)
		XCTAssertEqual(originalContents, readContents)
	}

	// MARK: - getUserDirectory

	func test_getUserDirectory() throws {
		let liveValue: FileManagerService = .liveValue
		let userDirectory = try withDependencies {
			$0.fileManager.getUserDirectory = liveValue.getUserDirectory
		} operation: {
			try fileManager.getUserDirectory()
		}

		XCTAssertEqual(try Self.getTempFolder(), userDirectory.appendingPathComponent("approach-tmp"))
	}

	// MARK: - exists

	func test_exists() throws {
		let liveValue: FileManagerService = .liveValue
		try withDependencies {
			$0.fileManager.exists = liveValue.exists
		} operation: {
			XCTAssertFalse(try fileManager.exists(try Self.getTempFolder()))
			XCTAssertNoThrow(
				try FileManager.default.createDirectory(at: try Self.getTempFolder(), withIntermediateDirectories: true)
			)
			XCTAssertTrue(try fileManager.exists(try Self.getTempFolder()))
		}
	}

	// MARK: - createDirectory

	func test_createDirectory() throws {
		let liveValue: FileManagerService = .liveValue
		try withDependencies {
			$0.fileManager.createDirectory = liveValue.createDirectory
		} operation: {
			XCTAssertFalse(FileManager.default.fileExists(atPath: try Self.getTempFolder().path()))
			XCTAssertNoThrow(try fileManager.createDirectory(try Self.getTempFolder()))
			XCTAssertTrue(FileManager.default.fileExists(atPath: try Self.getTempFolder().path()))
		}
	}

	// MARK: - contentsOfDirectory

	func test_contentsOfDirectory_emptyDirectory() throws {
		let liveValue: FileManagerService = .liveValue

		try FileManager.default.createDirectory(at: try Self.getTempFolder(), withIntermediateDirectories: true)

		let contents = try withDependencies {
			$0.fileManager.contentsOfDirectory = liveValue.contentsOfDirectory
		} operation: {
			try fileManager.contentsOfDirectory(at: Self.getTempFolder())
		}

		XCTAssertEqual(contents, [])
	}

	func test_contentsOfDirectory_withContents() throws {
		let liveValue: FileManagerService = .liveValue

		try FileManager.default.createDirectory(at: try Self.getTempFolder(), withIntermediateDirectories: true)

		let filePaths = try (0..<10).map { try Self.getTempFolder().appendingPathComponent("temp\($0).txt") }
		let originalContents = "file contents"
		let originalData = Data(originalContents.utf8)
		try filePaths.forEach { try originalData.write(to: $0) }

		let contents = try withDependencies {
			$0.fileManager.contentsOfDirectory = liveValue.contentsOfDirectory
		} operation: {
			try fileManager
				.contentsOfDirectory(at: Self.getTempFolder())
				.sorted(by: { $0.absoluteString < $1.absoluteString })
		}

		XCTAssertEqual(filePaths, contents)
	}

	// MARK: - copyItem

	func test_copyItem() throws {
		let liveValue: FileManagerService = .liveValue
		let originalContents = "file contents"
		let originalFilePath = try Self.getTempFolder().appendingPathComponent("temp.txt")
		let copiedFilePath = try Self.getTempFolder().appendingPathComponent("copy.txt")
		try FileManager.default.createDirectory(at: try Self.getTempFolder(), withIntermediateDirectories: true)
		let originalData = Data(originalContents.utf8)
		try originalData.write(to: originalFilePath)

		try withDependencies {
			$0.fileManager.copyItem = liveValue.copyItem
		} operation: {
			try fileManager.copyItem(at: originalFilePath, to: copiedFilePath)
		}

		XCTAssertTrue(FileManager.default.fileExists(atPath: originalFilePath.path()))
		XCTAssertTrue(FileManager.default.fileExists(atPath: copiedFilePath.path()))

		let readData = try XCTUnwrap(Data(contentsOf: copiedFilePath))
		let copiedContents = try XCTUnwrap(String(data: readData, encoding: .utf8))
		XCTAssertEqual(originalContents, copiedContents)
	}

	// MARK: - moveItem

	func test_moveItem() throws {
		let liveValue: FileManagerService = .liveValue
		let originalContents = "file contents"
		let originalFilePath = try Self.getTempFolder().appendingPathComponent("temp.txt")
		let movedFilePath = try Self.getTempFolder().appendingPathComponent("moved.txt")
		try FileManager.default.createDirectory(at: try Self.getTempFolder(), withIntermediateDirectories: true)
		let originalData = Data(originalContents.utf8)
		try originalData.write(to: originalFilePath)

		try withDependencies {
			$0.fileManager.moveItem = liveValue.moveItem
		} operation: {
			try fileManager.moveItem(at: originalFilePath, to: movedFilePath)
		}

		XCTAssertFalse(FileManager.default.fileExists(atPath: originalFilePath.path()))
		XCTAssertTrue(FileManager.default.fileExists(atPath: movedFilePath.path()))

		let readData = try XCTUnwrap(Data(contentsOf: movedFilePath))
		let movedContents = try XCTUnwrap(String(data: readData, encoding: .utf8))
		XCTAssertEqual(originalContents, movedContents)
	}

	// MARK: - remove

	func test_remove() throws {
		let liveValue: FileManagerService = .liveValue
		try withDependencies {
			$0.fileManager.remove = liveValue.remove
		} operation: {
			XCTAssertNoThrow(
				try FileManager.default.createDirectory(at: try Self.getTempFolder(), withIntermediateDirectories: true)
			)
			XCTAssertTrue(FileManager.default.fileExists(atPath: try Self.getTempFolder().path()))
			XCTAssertNoThrow(try fileManager.remove(try Self.getTempFolder()))
			XCTAssertFalse(FileManager.default.fileExists(atPath: try Self.getTempFolder().path()))
		}
	}
}

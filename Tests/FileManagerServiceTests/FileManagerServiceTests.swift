import Dependencies
@testable import FileManagerService
@testable import FileManagerServiceInterface
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
			try self.fileManager.getFileContents(filePath)
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
			try self.fileManager.getUserDirectory()
		}

		XCTAssertEqual(try Self.getTempFolder(), userDirectory.appendingPathComponent("approach-tmp"))
	}

	// MARK: - exists

	func test_exists() throws {
		let liveValue: FileManagerService = .liveValue
		try withDependencies {
			$0.fileManager.exists = liveValue.exists
			$0.fileManager.createDirectory = liveValue.createDirectory
		} operation: {
			XCTAssertFalse(try self.fileManager.exists(try Self.getTempFolder()))
			XCTAssertNoThrow(try fileManager.createDirectory(try Self.getTempFolder()))
			XCTAssertTrue(try fileManager.exists(try Self.getTempFolder()))
		}
	}

	// MARK: - createDirectory

	func test_createDirectory() throws {
		let liveValue: FileManagerService = .liveValue
		try withDependencies {
			$0.fileManager.exists = liveValue.exists
			$0.fileManager.createDirectory = liveValue.createDirectory
		} operation: {
			XCTAssertFalse(try self.fileManager.exists(try Self.getTempFolder()))
			XCTAssertNoThrow(try fileManager.createDirectory(try Self.getTempFolder()))
			XCTAssertTrue(try fileManager.exists(try Self.getTempFolder()))
		}
	}

	// MARK: - remove

	func test_remove() throws {
		let liveValue: FileManagerService = .liveValue
		try withDependencies {
			$0.fileManager.exists = liveValue.exists
			$0.fileManager.createDirectory = liveValue.createDirectory
			$0.fileManager.remove = liveValue.remove
		} operation: {
			XCTAssertNoThrow(try fileManager.createDirectory(try Self.getTempFolder()))
			XCTAssertTrue(try self.fileManager.exists(try Self.getTempFolder()))
			XCTAssertNoThrow(try fileManager.remove(try Self.getTempFolder()))
			XCTAssertFalse(try fileManager.exists(try Self.getTempFolder()))
		}
	}
}

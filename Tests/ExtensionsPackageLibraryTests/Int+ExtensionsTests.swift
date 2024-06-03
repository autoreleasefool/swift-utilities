@testable import ExtensionsPackageLibrary
import XCTest

final class IntExtensionsTests: XCTestCase {

	// MARK: - roundedTowardZero

	func test_roundedTowardZero_roundsZero() {
		XCTAssertEqual(0, 0.roundedTowardZero(toMultipleOf: 1))
		XCTAssertEqual(0, 0.roundedTowardZero(toMultipleOf: 5))
		XCTAssertEqual(0, 0.roundedTowardZero(toMultipleOf: 10))
	}

	func test_roundedTowardZero_roundsNegatives() {
		XCTAssertEqual(-5, (-8).roundedTowardZero(toMultipleOf: 5))
		XCTAssertEqual(-8, (-8).roundedTowardZero(toMultipleOf: 4))
		XCTAssertEqual(-8, (-9).roundedTowardZero(toMultipleOf: 2))
	}

	func test_roundedTowardZero_roundsPositives() {
		XCTAssertEqual(5, 8.roundedTowardZero(toMultipleOf: 5))
		XCTAssertEqual(8, 8.roundedTowardZero(toMultipleOf: 4))
		XCTAssertEqual(8, 9.roundedTowardZero(toMultipleOf: 2))
	}

	// MARK: - roundedAwayFromZero

	func test_roundedAwayFromdZero_roundsZero() {
		XCTAssertEqual(0, 0.roundedAwayFromZero(toMultipleOf: 1))
		XCTAssertEqual(0, 0.roundedAwayFromZero(toMultipleOf: 5))
		XCTAssertEqual(0, 0.roundedAwayFromZero(toMultipleOf: 10))
	}

	func test_roundedAwayFromZero_roundsNegatives() {
		XCTAssertEqual(-10, (-8).roundedAwayFromZero(toMultipleOf: 5))
		XCTAssertEqual(-8, (-8).roundedAwayFromZero(toMultipleOf: 4))
		XCTAssertEqual(-10, (-9).roundedAwayFromZero(toMultipleOf: 2))
	}

	func test_roundedAwayFromZero_roundsPositives() {
		XCTAssertEqual(10, 8.roundedAwayFromZero(toMultipleOf: 5))
		XCTAssertEqual(8, 8.roundedAwayFromZero(toMultipleOf: 4))
		XCTAssertEqual(10, 9.roundedAwayFromZero(toMultipleOf: 2))
	}

	// MARK: - roundedDown

	func test_roundedDown_roundsZero() {
		XCTAssertEqual(0, 0.roundedDown(toMultipleOf: 1))
		XCTAssertEqual(0, 0.roundedDown(toMultipleOf: 5))
		XCTAssertEqual(0, 0.roundedDown(toMultipleOf: 10))
	}

	func test_roundedDown_roundsNegatives() {
		XCTAssertEqual(-10, (-10).roundedDown(toMultipleOf: 1))
		XCTAssertEqual(-10, (-8).roundedDown(toMultipleOf: 5))
		XCTAssertEqual(-12, (-11).roundedDown(toMultipleOf: 2))
	}

	func test_roundedDown_roundsPositives() {
		XCTAssertEqual(10, 10.roundedDown(toMultipleOf: 1))
		XCTAssertEqual(5, 8.roundedDown(toMultipleOf: 5))
		XCTAssertEqual(10, 11.roundedDown(toMultipleOf: 2))
	}

	// MARK: - roundedUp

	func test_roundedUp_roundsZero() {
		XCTAssertEqual(0, 0.roundedUp(toMultipleOf: 1))
		XCTAssertEqual(0, 0.roundedUp(toMultipleOf: 5))
		XCTAssertEqual(0, 0.roundedUp(toMultipleOf: 10))
	}

	func test_roundedUp_roundsNegatives() {
		XCTAssertEqual(-10, (-10).roundedUp(toMultipleOf: 1))
		XCTAssertEqual(-5, (-8).roundedUp(toMultipleOf: 5))
		XCTAssertEqual(-10, (-11).roundedUp(toMultipleOf: 2))
	}

	func test_roundedUp_roundsPositives() {
		XCTAssertEqual(10, 10.roundedUp(toMultipleOf: 1))
		XCTAssertEqual(10, 8.roundedUp(toMultipleOf: 5))
		XCTAssertEqual(12, 11.roundedUp(toMultipleOf: 2))
	}
}

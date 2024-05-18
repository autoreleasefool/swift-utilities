import Dependencies
@testable import UserDefaultsPackageService
@testable import UserDefaultsPackageServiceInterface
import XCTest

final class UserDefaultsServiceTests: XCTestCase {
	@Dependency(\.userDefaults) var userDefaults

	func testRemovesKey() {
		let liveValue: UserDefaultsService = .liveValue

		withDependencies {
			$0.userDefaults.contains = liveValue.contains
			$0.userDefaults.remove = liveValue.remove
			$0.userDefaults.setString = liveValue.setString
			$0.userDefaults.string = liveValue.string
		} operation: {
			let key = "key"

			XCTAssertFalse(userDefaults.contains(key: key))
			XCTAssertNil(userDefaults.string(forKey: key))

			userDefaults.setString(forKey: key, to: "value")

			XCTAssertTrue(userDefaults.contains(key: key))
			XCTAssertNotNil(userDefaults.string(forKey: key))

			userDefaults.remove(key: key)

			XCTAssertFalse(userDefaults.contains(key: key))
			XCTAssertNil(userDefaults.string(forKey: key))
		}
	}

	func testStoreAndRetrievesBool() {
		let liveValue: UserDefaultsService = .liveValue

		withDependencies {
			$0.userDefaults.contains = liveValue.contains
			$0.userDefaults.remove = liveValue.remove
			$0.userDefaults.setBool = liveValue.setBool
			$0.userDefaults.bool = liveValue.bool
		} operation: {
			let key = "bool"

			XCTAssertFalse(userDefaults.contains(key: key))
			XCTAssertNil(userDefaults.bool(forKey: key))

			userDefaults.setBool(forKey: key, to: true)

			XCTAssertTrue(userDefaults.contains(key: key))
			XCTAssertEqual(true, userDefaults.bool(forKey: key))

			userDefaults.remove(key: key)

			XCTAssertFalse(userDefaults.contains(key: key))
			XCTAssertNil(userDefaults.bool(forKey: key))
		}
	}

	func testStoreAndRetrievesInt() {
		let liveValue = UserDefaultsService.liveValue

		withDependencies {
			$0.userDefaults.contains = liveValue.contains
			$0.userDefaults.remove = liveValue.remove
			$0.userDefaults.setInt = liveValue.setInt
			$0.userDefaults.int = liveValue.int
		} operation: {
			let key = "int"
			XCTAssertFalse(userDefaults.contains(key: key))
			XCTAssertNil(userDefaults.int(forKey: key))

			userDefaults.setInt(forKey: key, to: 101)

			XCTAssertTrue(userDefaults.contains(key: key))
			XCTAssertEqual(101, userDefaults.int(forKey: key))

			userDefaults.remove(key: key)

			XCTAssertFalse(userDefaults.contains(key: key))
			XCTAssertNil(userDefaults.int(forKey: key))
		}
	}

	func testStoreAndRetrievesFloat() {
		let liveValue = UserDefaultsService.liveValue

		withDependencies {
			$0.userDefaults.contains = liveValue.contains
			$0.userDefaults.remove = liveValue.remove
			$0.userDefaults.setFloat = liveValue.setFloat
			$0.userDefaults.float = liveValue.float
		} operation: {
			let key = "float"
			XCTAssertFalse(userDefaults.contains(key: key))
			XCTAssertNil(userDefaults.float(forKey: key))

			userDefaults.setFloat(forKey: key, to: 101.2)

			XCTAssertTrue(userDefaults.contains(key: key))
			XCTAssertEqual(101.2, userDefaults.float(forKey: key))

			userDefaults.remove(key: key)

			XCTAssertFalse(userDefaults.contains(key: key))
			XCTAssertNil(userDefaults.float(forKey: key))
		}
	}

	func testStoreAndRetrievesDouble() {
		let liveValue = UserDefaultsService.liveValue

		withDependencies {
			$0.userDefaults.contains = liveValue.contains
			$0.userDefaults.remove = liveValue.remove
			$0.userDefaults.setDouble = liveValue.setDouble
			$0.userDefaults.double = liveValue.double
		} operation: {
			let key = "double"
			XCTAssertFalse(userDefaults.contains(key: key))
			XCTAssertNil(userDefaults.double(forKey: key))

			userDefaults.setDouble(forKey: key, to: 101.2)

			XCTAssertTrue(userDefaults.contains(key: key))
			XCTAssertEqual(101.2, userDefaults.double(forKey: key))

			userDefaults.remove(key: key)

			XCTAssertFalse(userDefaults.contains(key: key))
			XCTAssertNil(userDefaults.double(forKey: key))
		}
	}

	func testStoreAndRetrievesString() {
		let liveValue = UserDefaultsService.liveValue

		withDependencies {
			$0.userDefaults.contains = liveValue.contains
			$0.userDefaults.remove = liveValue.remove
			$0.userDefaults.setString = liveValue.setString
			$0.userDefaults.string = liveValue.string
		} operation: {
			let key = "string"
			XCTAssertFalse(userDefaults.contains(key: key))
			XCTAssertNil(userDefaults.string(forKey: key))

			userDefaults.setString(forKey: key, to: "value")

			XCTAssertTrue(userDefaults.contains(key: key))
			XCTAssertEqual("value", userDefaults.string(forKey: key))

			userDefaults.remove(key: key)

			XCTAssertFalse(userDefaults.contains(key: key))
			XCTAssertNil(userDefaults.string(forKey: key))
		}
	}

	func testStoreAndRetrievesStringArray() {
		let liveValue = UserDefaultsService.liveValue

		withDependencies {
			$0.userDefaults.contains = liveValue.contains
			$0.userDefaults.remove = liveValue.remove
			$0.userDefaults.setStringArray = liveValue.setStringArray
			$0.userDefaults.stringArray = liveValue.stringArray
		} operation: {
			let key = "stringArray"
			XCTAssertFalse(userDefaults.contains(key: key))
			XCTAssertNil(userDefaults.stringArray(forKey: key))

			userDefaults.setStringArray(forKey: key, to: ["value1", "value2"])

			XCTAssertTrue(userDefaults.contains(key: key))
			XCTAssertEqual(["value1", "value2"], userDefaults.stringArray(forKey: key))

			userDefaults.remove(key: key)

			XCTAssertFalse(userDefaults.contains(key: key))
			XCTAssertNil(userDefaults.stringArray(forKey: key))
		}
	}

	func testSubscribe_ReceivesChanges() async {
		let liveValue = UserDefaultsService.liveValue

		await withDependencies {
			$0.userDefaults.contains = liveValue.contains
			$0.userDefaults.remove = liveValue.remove
			$0.userDefaults.setString = liveValue.setString
			$0.userDefaults.setBool = liveValue.setBool
			$0.userDefaults.observe = liveValue.observe
		} operation: {
			var observations = userDefaults.observe(
				keys: ["appDidCompleteOnboarding", "username"]
			).makeAsyncIterator()

			userDefaults.setBool(forKey: "appDidCompleteOnboarding", to: true)
			userDefaults.setString(forKey: "username", to: "test")
			userDefaults.remove(key: "appDidCompleteOnboarding")

			let firstObservation = await observations.next()
			XCTAssertEqual(firstObservation, "appDidCompleteOnboarding")

			let secondObservation = await observations.next()
			XCTAssertEqual(secondObservation, "username")

			let thirdObservation = await observations.next()
			XCTAssertEqual(thirdObservation, "appDidCompleteOnboarding")
		}
	}

	func testSubscribe_DoesNotReceiveUnrelatedChanges() async {
		let liveValue = UserDefaultsService.liveValue

		await withDependencies {
			$0.userDefaults.contains = liveValue.contains
			$0.userDefaults.remove = liveValue.remove
			$0.userDefaults.setBool = liveValue.setBool
			$0.userDefaults.setString = liveValue.setString
			$0.userDefaults.observe = liveValue.observe
		} operation: {
			var observations = userDefaults.observe(
				keys: ["appDidCompleteOnboarding"]
			).makeAsyncIterator()

			userDefaults.setBool(forKey: "appDidCompleteOnboarding", to: true)
			userDefaults.setString(forKey: "username", to: "test")
			userDefaults.remove(key: "appDidCompleteOnboarding")

			let firstObservation = await observations.next()
			XCTAssertEqual(firstObservation, "appDidCompleteOnboarding")

			let secondObservation = await observations.next()
			XCTAssertEqual(secondObservation, "appDidCompleteOnboarding")
		}
	}
}

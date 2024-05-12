import Dependencies
@testable import FeatureFlagsLibrary
@testable import FeatureFlagsService
@testable import FeatureFlagsServiceInterface
import UserDefaultsServiceInterface
import XCTest

final class FeatureFlagsServiceTests: XCTestCase {
	let testQueue = DispatchQueue(label: "TestQueue")

	@Dependency(\.featureFlags) var featureFlags

	override func invokeTest() {
		withDependencies {
			$0.featureFlagsQueue = testQueue
		} operation: {
			super.invokeTest()
		}
	}

	override func tearDown() {
		// Wait for all changes to clean up
		testQueue.sync { }
	}

	// MARK: - initialize

	func test_initialize_readsFromUserDefaults() throws {
		let overrides = LockIsolated<[String: Bool]>([
			"FeatureFlag.Override.Release": false,
			"FeatureFlag.Override.Disabled": true,
		])

		try withDependencies {
			$0.userDefaults.bool = { @Sendable key in overrides.value[key] }
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: FeatureFlag.all)

			let isDisabledFlagEnabled = try self.featureFlags.isEnabled(.disabled)
			XCTAssertTrue(isDisabledFlagEnabled)

			let isReleaseFlagEnabled = try self.featureFlags.isEnabled(.release)
			XCTAssertFalse(isReleaseFlagEnabled)
		}
	}

	// MARK: - isEnabled

	func test_isEnabled_whenEnabled_isTrue() throws {
		let isEnabled = try withDependencies {
			$0.userDefaults.bool = { @Sendable _ in nil }
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: FeatureFlag.all)
			return try self.featureFlags.isEnabled(.release)
		}

		XCTAssertTrue(isEnabled)
	}

	func test_isEnabled_whenDisabled_isFalse() throws {
		let isEnabled = try withDependencies {
			$0.userDefaults.bool = { @Sendable _ in nil }
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: FeatureFlag.all)
			return try self.featureFlags.isEnabled(.disabled)
		}

		XCTAssertFalse(isEnabled)
	}

	// MARK: - allEnabled

	func test_allEnabled_whenAllFlagsEnabled_returnsTrue() throws {
		let flags = [
			FeatureFlag(name: "Test1", introduced: "", stage: .release),
			 FeatureFlag(name: "Test2", introduced: "", stage: .release),
			 FeatureFlag(name: "Test3", introduced: "", stage: .release),
		 ]

		let allEnabled = try withDependencies {
			$0.userDefaults.bool = { @Sendable _ in nil }
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: flags)
			return try self.featureFlags.allEnabled(flags)
		}

		XCTAssertTrue(allEnabled)
	}

	func test_allEnabled_whenSomeDisabled_returnsFalse() throws {
		let flags = [
			FeatureFlag(name: "Test1", introduced: "", stage: .release),
			FeatureFlag(name: "Test2", introduced: "", stage: .disabled),
			FeatureFlag(name: "Test3", introduced: "", stage: .release),
		]

		let allEnabled = try withDependencies {
			$0.userDefaults.bool = { @Sendable _ in nil }
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: flags)
			return try self.featureFlags.allEnabled(flags)
		}

		XCTAssertFalse(allEnabled)
	}

	func test_allEnabled_whenAllDisabled_returnsFalse() throws {
		let flags = [
			FeatureFlag(name: "Test1", introduced: "", stage: .disabled),
			FeatureFlag(name: "Test2", introduced: "", stage: .disabled),
			FeatureFlag(name: "Test3", introduced: "", stage: .disabled),
		]

		let allEnabled = try withDependencies {
			$0.userDefaults.bool = { @Sendable _ in nil }
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: flags)
			return try self.featureFlags.allEnabled(flags)
		}

		XCTAssertFalse(allEnabled)
	}

	// MARK: - observe

	func test_observe_whenFlagChanges_receivesChange() async throws {
		try await withDependencies {
			$0.userDefaults.bool = { @Sendable _ in nil }
			$0.userDefaults.setBool = { @Sendable _, _ in }
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: FeatureFlag.all)

			var observations = try self.featureFlags.observe(flag: .release).makeAsyncIterator()

			var observation = await observations.next()
			XCTAssertEqual(observation, true)

			featureFlags.setEnabled(.release, false)

			observation = await observations.next()
			XCTAssertEqual(observation, false)
		}
	}

	func test_observe_whenOtherFlagChanges_doesNotReceiveChange() async throws {
		try await withDependencies {
			$0.userDefaults.bool = { @Sendable _ in nil }
			$0.userDefaults.setBool = { @Sendable _, _ in }
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: FeatureFlag.all)

			var observations = try self.featureFlags.observe(flag: .release).makeAsyncIterator()

			var observation = await observations.next()
			XCTAssertEqual(observation, true)

			featureFlags.setEnabled(.development, false)
			featureFlags.setEnabled(.release, true)

			observation = await observations.next()
			XCTAssertEqual(observation, true)
		}
	}

	// MARK: - observeAll

	func test_observeAll_whenAnyObservedFlagChanges_receivesChanges() async throws {
		try await withDependencies {
			$0.userDefaults.bool = { @Sendable _ in nil }
			$0.userDefaults.setBool = { @Sendable _, _ in }
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: FeatureFlag.all)

			var observations = try self.featureFlags.observeAll(flags: [.release, .development]).makeAsyncIterator()

			var observation = await observations.next()
			XCTAssertEqual(observation, [.release: true, .development: true])

			featureFlags.setEnabled(.development, false)
			featureFlags.setEnabled(.release, false)

			observation = await observations.next()
			XCTAssertEqual(observation, [.release: true, .development: false])

			observation = await observations.next()
			XCTAssertEqual(observation, [.release: false, .development: false])
		}
	}

	func test_observeAll_whenAnyUnobservedFlagChanges_doesNotReceiveChange() async throws {
		try await withDependencies {
			$0.userDefaults.bool = { @Sendable _ in nil }
			$0.userDefaults.setBool = { @Sendable _, _ in }
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: FeatureFlag.all)

			var observations = try self.featureFlags.observeAll(flags: [.release, .development]).makeAsyncIterator()

			var observation = await observations.next()
			XCTAssertEqual(observation, [.release: true, .development: true])

			featureFlags.setEnabled(.development, false)
			featureFlags.setEnabled(.test, false)

			observation = await observations.next()
			XCTAssertEqual(observation, [.release: true, .development: false])
		}
	}

	// MARK: - setEnabled

	func test_setEnabled_publishesNotification() async throws {
		try await withDependencies {
			$0.userDefaults.bool = { @Sendable _ in nil }
			$0.userDefaults.setBool = { @Sendable _, _ in }
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: FeatureFlag.all)

			let notifications = NotificationCenter.default
				.notifications(named: .FeatureFlag.didChange)
				.makeAsyncIterator()

			self.featureFlags.setEnabled(.release, false)

			let notification = await notifications.next()
			let changedFlag = try XCTUnwrap(notification?.object as? FeatureFlag)
			XCTAssertEqual(changedFlag, .release)
		}
	}

	func test_setEnabled_overridesIsEnabled() throws {
		try withDependencies {
			$0.userDefaults.bool = { @Sendable _ in nil }
			$0.userDefaults.setBool = { @Sendable _, _ in }
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: FeatureFlag.all)

			var isEnabled = try self.featureFlags.isEnabled(.release)
			XCTAssertTrue(isEnabled)

			self.featureFlags.setEnabled(.release, false)
			isEnabled = try self.featureFlags.isEnabled(.release)
			XCTAssertFalse(isEnabled)

			self.featureFlags.setEnabled(.release, true)
			isEnabled = try self.featureFlags.isEnabled(.release)
			XCTAssertTrue(isEnabled)
		}
	}

	func test_setEnabled_persistsChanges() throws {
		let overrides = LockIsolated<[String: Bool]>([:])
		let expectation = self.expectation(description: "overridden value")

		withDependencies {
			$0.userDefaults.bool = { @Sendable key in overrides.value[key] }
			$0.userDefaults.setBool = { @Sendable key, value in
				overrides.withValue { $0[key] = value }
				expectation.fulfill()
			}
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: FeatureFlag.all)

			XCTAssertEqual(overrides.value, [:])

			self.featureFlags.setEnabled(.release, false)

			wait(for: [expectation], timeout: 1.0)

			XCTAssertEqual(overrides.value, ["FeatureFlag.Override.Release": false])
		}
	}

	func test_setEnabled_withOverridesDisabled_doesNotUpdate() throws {
		let overrides = LockIsolated<[String: Bool]>([:])

		try withDependencies {
			$0.userDefaults.bool = { @Sendable key in overrides.value[key] }
			$0.userDefaults.setBool = { @Sendable key, value in overrides.withValue { $0[key] = value } }
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: FeatureFlag.all)

			var isEnabled = try self.featureFlags.isEnabled(.notOverridable)
			XCTAssertTrue(isEnabled)

			XCTAssertEqual(overrides.value, [:])

			self.featureFlags.setEnabled(.notOverridable, false)

			isEnabled = try self.featureFlags.isEnabled(.notOverridable)
			XCTAssertTrue(isEnabled)
			XCTAssertEqual(overrides.value, [:])
		}
	}

	// MARK: - resetOverrides

	func test_resetOverrides_resets() async throws {
		let overrides = LockIsolated<[String: Bool]>([
			"FeatureFlag.Override.Release": true,
			"FeatureFlag.Override.Development": false,
		])

		withDependencies {
			$0.userDefaults.bool = { @Sendable key in overrides.value[key] }
			$0.userDefaults.setBool = { @Sendable key, value in overrides.withValue { $0[key] = value } }
			$0.userDefaults.remove = { @Sendable key in overrides.withValue { $0[key] = nil } }
			$0.featureFlags = .liveValue
		} operation: {
			self.featureFlags.initialize(registeringFeatureFlags: FeatureFlag.all)

			XCTAssertEqual(overrides.value, [
				"FeatureFlag.Override.Release": true,
				"FeatureFlag.Override.Development": false,
			])

			self.featureFlags.resetOverrides()

			XCTAssertEqual(overrides.value, [:])
		}
	}
}

extension FeatureFlag {
	static let disabled = Self(name: "Disabled", introduced: "2024-05-10", stage: .disabled)
	static let test = Self(name: "Test", introduced: "2024-05-10", stage: .test)
	static let development = Self(name: "Development", introduced: "2024-05-10", stage: .development)
	static let release = Self(name: "Release", introduced: "2024-05-10", stage: .release)
	static let notOverridable = Self(
		name: "Not Overridable",
		introduced: "2024-05-10",
		stage: .development,
		isOverridable: false
	)

	static let all: [FeatureFlag] = [
		.disabled,
		.test,
		.development,
		.release,
		.notOverridable,
	]
}

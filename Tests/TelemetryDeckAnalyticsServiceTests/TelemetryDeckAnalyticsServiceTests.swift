@testable import AnalyticsServiceInterface
import BundleServiceInterface
import Dependencies
@testable import TelemetryDeckAnalyticsService
import UserDefaultsServiceInterface
import XCTest

final class TelemetryDeckAnalyticsServiceTests: XCTestCase {
	@Dependency(\.analytics) var analytics

	// MARK: - initialize

	func test_initialize_withNoBundleKey_disablesAnalytics() throws {
		let liveValue: AnalyticsService = .liveValue
		let expectation = self.expectation(description: "initialized")

		try withDependencies {
			$0.userDefaults.string = { @Sendable _ in Analytics.OptInStatus.optedIn.rawValue }
			$0.bundle.object = { @Sendable _ in nil }
			$0[TelemetryDeckClient.self].initialize = { @Sendable configuration in
				XCTAssertTrue(configuration.analyticsDisabled)
				expectation.fulfill()
			}
			$0.analytics.initialize = liveValue.initialize
		} operation: {
			try self.analytics.initialize()
		}

		waitForExpectations(timeout: 1.0)
	}

	func test_intialize_withOptedInStatusOptedOut_disablesAnalytics() throws {
		let liveValue: AnalyticsService = .liveValue
		let expectation = self.expectation(description: "initialized")

		try withDependencies {
			$0.userDefaults.string = { @Sendable _ in Analytics.OptInStatus.optedOut.rawValue }
			$0.bundle.object = { @Sendable _ in "key" }
			$0[TelemetryDeckClient.self].initialize = { @Sendable configuration in
				XCTAssertTrue(configuration.analyticsDisabled)
				expectation.fulfill()
			}
			$0.analytics.initialize = liveValue.initialize
		} operation: {
			try self.analytics.initialize()
		}

		waitForExpectations(timeout: 1.0)
	}

	func test_initialize_withBundleKey_withOptedInStatusOptedIn_enablesAnalytics() throws {
		let liveValue: AnalyticsService = .liveValue

		let expectation = self.expectation(description: "initialized")
		try withDependencies {
			$0.userDefaults.string = { @Sendable _ in Analytics.OptInStatus.optedIn.rawValue }
			$0.bundle.object = { @Sendable _ in "key" }
			$0[TelemetryDeckClient.self].initialize = { @Sendable configuration in
				XCTAssertFalse(configuration.analyticsDisabled)
				expectation.fulfill()
			}
			$0.analytics.initialize = liveValue.initialize
		} operation: {
			try self.analytics.initialize()
		}

		waitForExpectations(timeout: 1.0)
	}

	// MARK: - trackEvent

	func test_trackEvent_sendsEvent() async throws {
		let liveValue: AnalyticsService = .liveValue
		let expectation = self.expectation(description: "event tracked")

		try await withDependencies {
			$0.analytics.trackEvent = liveValue.trackEvent
			$0[TelemetryDeckClient.self].send = { @Sendable name, payload in
				XCTAssertEqual(name, "PayloadMock")
				XCTAssertEqual(payload, [
					"1": "First",
					"2": "Second",
				])
				expectation.fulfill()
			}
		} operation: {
			try await self.analytics.trackEvent(PayloadMockEvent())
		}

		await fulfillment(of: [expectation])
	}

	func test_trackEvent_withGlobalProperties_mergesProperties() async throws {
		let liveValue: AnalyticsService = .liveValue
		let expectation = self.expectation(description: "event tracked")

		try await withDependencies {
			$0.analytics.trackEvent = liveValue.trackEvent
			$0.analytics.setGlobalProperty = liveValue.setGlobalProperty
			$0[TelemetryDeckClient.self].send = { @Sendable name, payload in
				XCTAssertEqual(name, "PayloadMock")
				XCTAssertEqual(payload, [
					"1": "First",
					"2": "Second",
					"3": "Third",
				])
				expectation.fulfill()
			}
		} operation: {
			try await self.analytics.setGlobalProperty(key: "2", value: "Overridden")
			try await self.analytics.setGlobalProperty(key: "3", value: "Third")
			try await self.analytics.trackEvent(PayloadMockEvent())
		}

		await fulfillment(of: [expectation])
	}

	// MARK: setGlobalProperties

	func test_setGlobalProperty_setsPropertyForAllRequests() async throws {
		let liveValue: AnalyticsService = .liveValue
		let expectation = self.expectation(description: "event tracked")
		expectation.expectedFulfillmentCount = 2

		try await withDependencies {
			$0.analytics.setGlobalProperty = liveValue.setGlobalProperty
		} operation: {
			try await self.analytics.setGlobalProperty(key: "1", value: "First")
		}

		try await withDependencies {
			$0.analytics.trackEvent = liveValue.trackEvent
			$0[TelemetryDeckClient.self].send = { @Sendable name, payload in
				XCTAssertEqual(name, "BasicMock")
				XCTAssertEqual(payload, ["1": "First"])
				expectation.fulfill()
			}
		} operation: {
			try await self.analytics.trackEvent(BasicMockEvent())
		}

		try await withDependencies {
			$0.analytics.trackEvent = liveValue.trackEvent
			$0[TelemetryDeckClient.self].send = { @Sendable name, payload in
				XCTAssertEqual(name, "BasicMock")
				XCTAssertEqual(payload, ["1": "First"])
				expectation.fulfill()
			}
		} operation: {
			try await self.analytics.trackEvent(BasicMockEvent())
		}

		await fulfillment(of: [expectation])
	}

	func test_setGlobalProperty_removesProperty() async throws {
		let liveValue: AnalyticsService = .liveValue
		let expectation = self.expectation(description: "event tracked")
		expectation.expectedFulfillmentCount = 2

		try await withDependencies {
			$0.analytics.setGlobalProperty = liveValue.setGlobalProperty
		} operation: {
			try await self.analytics.setGlobalProperty(key: "1", value: "First")
		}

		try await withDependencies {
			$0.analytics.trackEvent = liveValue.trackEvent
			$0[TelemetryDeckClient.self].send = { @Sendable name, payload in
				XCTAssertEqual(name, "BasicMock")
				XCTAssertEqual(payload, ["1": "First"])
				expectation.fulfill()
			}
		} operation: {
			try await self.analytics.trackEvent(BasicMockEvent())
		}

		try await withDependencies {
			$0.analytics.setGlobalProperty = liveValue.setGlobalProperty
		} operation: {
			try await self.analytics.setGlobalProperty(key: "1", value: nil)
		}

		try await withDependencies {
			$0.analytics.trackEvent = liveValue.trackEvent
			$0[TelemetryDeckClient.self].send = { @Sendable name, payload in
				XCTAssertEqual(name, "BasicMock")
				XCTAssertEqual(payload, [:])
				expectation.fulfill()
			}
		} operation: {
			try await self.analytics.trackEvent(BasicMockEvent())
		}

		await fulfillment(of: [expectation])
	}

	// MARK: setOptInStatus

	func test_setOptInStatus_setsValueInUserDefaults() async throws {
		let liveValue: AnalyticsService = .liveValue
		let optInStatus = LockIsolated<Analytics.OptInStatus>(.optedIn)

		try await withDependencies {
			$0.analytics.setOptInStatus = liveValue.setOptInStatus
			$0[TelemetryDeckClient.self].terminate = { @Sendable in }
			$0[TelemetryDeckClient.self].initialize = { @Sendable _ in }
			$0.bundle.object = { @Sendable _ in nil }
			$0.userDefaults.string = { @Sendable _ in optInStatus.rawValue }
			$0.userDefaults.setString = { @Sendable _, value in
				let newValue = Analytics.OptInStatus(rawValue: value)!
				optInStatus.setValue(newValue)
			}
		} operation: {
			try await self.analytics.setOptInStatus(.optedOut)
		}

		XCTAssertEqual(optInStatus.value, .optedOut)
	}

	func test_setOptInStatus_reinitializesTelemetryDeck() async throws {
		let liveValue: AnalyticsService = .liveValue
		let terminateExpectation = self.expectation(description: "terminated")
		let initializeExpectation = self.expectation(description: "initialized")

		try await withDependencies {
			$0.analytics.setOptInStatus = liveValue.setOptInStatus
			$0[TelemetryDeckClient.self].terminate = { @Sendable in
				terminateExpectation.fulfill()
			}
			$0[TelemetryDeckClient.self].initialize = { @Sendable _ in
				initializeExpectation.fulfill()
			}
			$0.bundle.object = { @Sendable _ in nil }
			$0.userDefaults.string = { @Sendable _ in Analytics.OptInStatus.optedIn.rawValue }
			$0.userDefaults.setString = { @Sendable _, _ in }
		} operation: {
			try await self.analytics.setOptInStatus(.optedOut)
		}

		await fulfillment(of: [terminateExpectation, initializeExpectation])
	}

	// MARK: - getOptInStatus

	func test_getOptInStatus_returnsValue() async throws {
		let liveValue: AnalyticsService = .liveValue
		let optInStatusCache = LockIsolated<Analytics.OptInStatus>(.optedOut)

		let optInStatus = withDependencies {
			$0.analytics.getOptInStatus = liveValue.getOptInStatus
			$0.userDefaults.string = { @Sendable _ in optInStatusCache.rawValue }
		} operation: {
			self.analytics.getOptInStatus()
		}

		XCTAssertEqual(optInStatus, optInStatusCache.value)
	}

	func test_getOptInStatus_isOptInByDefault() async throws {
		let liveValue: AnalyticsService = .liveValue

		let optInStatus = withDependencies {
			$0.analytics.getOptInStatus = liveValue.getOptInStatus
			$0.userDefaults.string = { @Sendable _ in nil }
		} operation: {
			self.analytics.getOptInStatus()
		}

		XCTAssertEqual(optInStatus, .optedIn)
	}
}

struct PayloadMockEvent: TrackableEvent {
	public let name: String = "PayloadMock"
	public let payload: [String: String]? = [
		"1": "First",
		"2": "Second",
	]
}

struct BasicMockEvent: TrackableEvent {
	public let name: String = "BasicMock"
	public let payload: [String: String]? = nil
}

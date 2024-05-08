@testable import ExtensionsLibrary
import SwiftUI
import XCTest

final class BindingsExtensionTests: XCTestCase {
	func test_isPresent_whenNil_isFalse() {
		var bindingValue: Value? = nil
		let binding: Binding<Value?> = Binding(get: { bindingValue }, set: { bindingValue = $0 })

		XCTAssertFalse(binding.isPresent().wrappedValue)
	}

	func test_isPresent_whenNotNil_isTrue() {
		var bindingValue: Value? = Value(value: "test")
		let binding: Binding<Value?> = Binding(get: { bindingValue }, set: { bindingValue = $0 })

		XCTAssertTrue(binding.isPresent().wrappedValue)
	}

	func test_isPresent_whenSetToTrue_doesNothing() {
		var bindingValue: Value? = Value(value: "test")
		let binding: Binding<Value?> = Binding(get: { bindingValue }, set: { bindingValue = $0 })

		binding.isPresent().wrappedValue = true
		XCTAssertTrue(binding.isPresent().wrappedValue)
		XCTAssertEqual(binding.wrappedValue, Value(value: "test"))
	}

	func test_isPresent_whenSetToFalse_setsValueToNil() {
		var bindingValue: Value? = Value(value: "test")
		let binding: Binding<Value?> = Binding(get: { bindingValue }, set: { bindingValue = $0 })

		binding.isPresent().wrappedValue = false
		XCTAssertFalse(binding.isPresent().wrappedValue)
		XCTAssertNil(binding.wrappedValue)
	}
}

private struct Value: Equatable {
	let value: String
}

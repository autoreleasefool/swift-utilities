import ConcurrencyExtras
@testable import ExtensionsPackageLibrary
import SwiftUI
import Testing

struct BindingsTests {
	struct IsPresent {
		@Test func whenNil_isFalse() {
			let bindingValue = LockIsolated<Value?>(nil)
			let binding: Binding<Value?> = Binding(
				get: { bindingValue.value },
				set: { bindingValue.setValue($0) }
			)

			#expect(binding.isPresent().wrappedValue == false)
		}

		@Test func whenNotNil_isTrue() {
			let bindingValue = LockIsolated<Value?>(Value(value: "test"))
			let binding: Binding<Value?> = Binding(
				get: { bindingValue.value },
				set: { bindingValue.setValue($0) }
			)

			#expect(binding.isPresent().wrappedValue == true)
		}

		@Test func whenSetToTrue_doesNothing() {
			let bindingValue = LockIsolated<Value?>(Value(value: "test"))
			let binding: Binding<Value?> = Binding(
				get: { bindingValue.value },
				set: { bindingValue.setValue($0) }
			)

			binding.isPresent().wrappedValue = true

			#expect(binding.isPresent().wrappedValue == true)
			#expect(binding.wrappedValue == Value(value: "test"))
		}

		@Test func whenSetToFalse_setsValueToNil() {
			let bindingValue = LockIsolated<Value?>(Value(value: "test"))
			let binding: Binding<Value?> = Binding(
				get: { bindingValue.value },
				set: { bindingValue.setValue($0) }
			)

			binding.isPresent().wrappedValue = false

			#expect(binding.isPresent().wrappedValue == false)
			#expect(binding.wrappedValue == nil)
		}
	}
}

private struct Value: Equatable {
	let value: String
}

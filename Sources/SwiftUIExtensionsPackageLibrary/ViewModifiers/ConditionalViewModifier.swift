import SwiftUI

extension View {
	@ViewBuilder public func `if`<Content: View>(
		_ condition: @autoclosure () -> Bool,
		transform: (Self) -> Content
	) -> some View {
		if condition() {
			transform(self)
		} else {
			self
		}
	}
}

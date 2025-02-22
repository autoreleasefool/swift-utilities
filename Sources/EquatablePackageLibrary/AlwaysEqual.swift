@dynamicMemberLookup
public struct AlwaysEqual<V>: Equatable {
	public let wrapped: V
	public init(_ wrapped: V) {
		self.wrapped = wrapped
	}

	public static func == (lhs: Self, rhs: Self) -> Bool {
		true
	}

	public subscript<T>(dynamicMember keyPath: KeyPath<V, T>) -> T {
		self.wrapped[keyPath: keyPath]
	}
}

extension AlwaysEqual: Sendable where V: Sendable {}

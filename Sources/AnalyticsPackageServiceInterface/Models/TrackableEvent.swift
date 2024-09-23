public protocol TrackableEvent: Sendable {
	var name: String { get }
	var payload: [String: String]? { get }
}

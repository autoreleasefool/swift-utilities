public protocol TrackableEvent {
	var name: String { get }
	var payload: [String: String]? { get }
}

public enum Analytics {}

extension Analytics {
	public enum OptInStatus: String, Sendable {
		case optedIn
		case optedOut
	}
}

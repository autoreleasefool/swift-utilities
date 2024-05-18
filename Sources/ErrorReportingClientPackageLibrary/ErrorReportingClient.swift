import Dependencies
import DependenciesMacros

@DependencyClient
public struct ErrorReportingClient: Sendable {
	public var captureError: @Sendable (any Error) -> Void
	public var captureMessage: @Sendable (String) -> Void
}

extension ErrorReportingClient: TestDependencyKey {
	public static var testValue = Self()
}

extension DependencyValues {
	public var errors: ErrorReportingClient {
		get { self[ErrorReportingClient.self] }
		set { self[ErrorReportingClient.self] = newValue }
	}
}

import Dependencies
import ErrorReportingClientLibrary
import Sentry

extension ErrorReportingClient: DependencyKey {
	public static var liveValue = live()

	static func live() -> Self {
		Self(
			captureError: { error in SentrySDK.capture(error: error) },
			captureMessage: { message in SentrySDK.capture(message: message) }
		)
	}
}

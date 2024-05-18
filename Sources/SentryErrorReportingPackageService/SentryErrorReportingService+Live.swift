import Dependencies
import ErrorReportingClientPackageLibrary
import Sentry

extension ErrorReportingClient: DependencyKey {
	public static var liveValue: Self {
		Self(
			captureError: { error in SentrySDK.capture(error: error) },
			captureMessage: { message in SentrySDK.capture(message: message) }
		)
	}
}

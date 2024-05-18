import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct AppInfoService: Sendable {
	public var initialize: @Sendable () async -> Void
	public var getNumberOfSessions: @Sendable () -> Int = { XCTFail("\(Self.self).getNumberOfSessions"); return 0 }
	public var getInstallDate: @Sendable () -> Date = {
		XCTFail("\(Self.self).getInstallDate")
		return Date(timeIntervalSince1970: 0)
	}
	public var getAppVersion: @Sendable () -> String = { XCTFail("\(Self.self).getAppVersion"); return "" }
	public var getBuildVersion: @Sendable () -> String = { XCTFail("\(Self.self).getBuildVersion"); return "" }
	public var getFullAppVersion: @Sendable () -> String = { XCTFail("\(Self.self).getFullAppVersion"); return "" }
}

extension AppInfoService: TestDependencyKey {
	public static var testValue = Self()
}

extension DependencyValues {
	public var appInfo: AppInfoService {
		get { self[AppInfoService.self] }
		set { self[AppInfoService.self] = newValue }
	}
}

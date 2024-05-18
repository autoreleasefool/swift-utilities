import Dependencies
import DependenciesMacros

@DependencyClient
public struct UserDefaultsService: Sendable {
	public var bool: @Sendable (_ forKey: String) -> Bool?
	public var setBool: @Sendable (_ forKey: String, _ to: Bool) -> Void
	public var double: @Sendable (_ forKey: String) -> Double?
	public var setDouble: @Sendable (_ forKey: String, _ to: Double) -> Void
	public var float: @Sendable (_ forKey: String) -> Float?
	public var setFloat: @Sendable (_ forKey: String, _ to: Float) -> Void
	public var int: @Sendable (_ forKey: String) -> Int?
	public var setInt: @Sendable (_ forKey: String, _ to: Int) -> Void
	public var string: @Sendable (_ forKey: String) -> String?
	public var setString: @Sendable (_ forKey: String, _ to: String) -> Void
	public var stringArray: @Sendable (_ forKey: String) -> [String]?
	public var setStringArray: @Sendable (_ forKey: String, _ to: [String]) -> Void
	public var contains: @Sendable (_ key: String) -> Bool = { _ in unimplemented("\(Self.self).contains") }
	public var remove: @Sendable (_ key: String) -> Void
	public var observe: @Sendable (_ keys: Set<String>) -> AsyncStream<String> = { _ in
		unimplemented("\(Self.self).observe")
	}
}

extension UserDefaultsService: TestDependencyKey {
	public static var testValue = Self()
}

extension DependencyValues {
	public var userDefaults: UserDefaultsService {
		get { self[UserDefaultsService.self] }
		set { self[UserDefaultsService.self] = newValue }
	}
}

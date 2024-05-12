import Dependencies
import Foundation
import UserDefaultsServiceInterface

extension NSNotification.Name {
	enum UserDefaults {
		static let didChange = NSNotification.Name("UserDefaults.didChange")
	}
}

extension UserDefaultsService: DependencyKey {
	public static var liveValue: Self {
		let userDefaults = UncheckedSendable(UserDefaults.standard)

		@Sendable func contains(_ key: String) -> Bool {
			userDefaults.value.object(forKey: key) != nil
		}

		return Self(
			bool: { key in contains(key) ? userDefaults.value.bool(forKey: key) : nil },
			setBool: { key, value in
				userDefaults.value.set(value, forKey: key)
				NotificationCenter.default.post(name: .UserDefaults.didChange, object: key)
			},
			double: { key in contains(key) ? userDefaults.value.double(forKey: key) : nil },
			setDouble: { key, value in
				userDefaults.value.set(value, forKey: key)
				NotificationCenter.default.post(name: .UserDefaults.didChange, object: key)
			},
			float: { key in contains(key) ? userDefaults.value.float(forKey: key) : nil },
			setFloat: { key, value in
				userDefaults.value.set(value, forKey: key)
				NotificationCenter.default.post(name: .UserDefaults.didChange, object: key)
			},
			int: { key in contains(key) ? userDefaults.value.integer(forKey: key) : nil },
			setInt: { key, value in
				userDefaults.value.set(value, forKey: key)
				NotificationCenter.default.post(name: .UserDefaults.didChange, object: key)
			},
			string: { key in contains(key) ? userDefaults.value.string(forKey: key) : nil },
			setString: { key, value in
				userDefaults.value.set(value, forKey: key)
				NotificationCenter.default.post(name: .UserDefaults.didChange, object: key)
			},
			stringArray: { key in contains(key) ? userDefaults.value.stringArray(forKey: key) : nil },
			setStringArray: { key, value in
				userDefaults.value.set(value, forKey: key)
				NotificationCenter.default.post(name: .UserDefaults.didChange, object: key)
			},
			contains: contains(_:),
			remove: { key in
				userDefaults.value.removeObject(forKey: key)
				NotificationCenter.default.post(name: .UserDefaults.didChange, object: key)
			},
			observe: { keys in
				.init { continuation in
					let cancellable = NotificationCenter.default
						.publisher(for: .UserDefaults.didChange)
						.compactMap {
							guard let key = $0.object as? String, keys.contains(key) else { return nil }
							return key
						}
						.sink { key in
							continuation.yield(key)
						}

					continuation.onTermination = { _ in cancellable.cancel() }
				}
			}
		)
	}
}

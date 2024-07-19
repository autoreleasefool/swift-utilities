@preconcurrency import Combine
import Dependencies
import FeatureFlagsPackageLibrary
import FeatureFlagsPackageServiceInterface
import Foundation
import UserDefaultsPackageServiceInterface

extension NSNotification.Name {
	enum FeatureFlag {
		static let didChange = NSNotification.Name("FeatureFlag.didChange")
	}
}

extension FeatureFlagsService: DependencyKey {
	public static var liveValue: Self {
		let flagOverrides = LockIsolated<[FeatureFlag: Bool]>([:])

		@Sendable func isFlagEnabled(flag: FeatureFlag) -> Bool {
			#if DEBUG
			return flagOverrides.value[flag] ?? flag.isEnabled
			#else
			return flag.isEnabled
			#endif
		}

		@Sendable func areFlagsEnabled(flags: [FeatureFlag]) -> [FeatureFlag: Bool] {
			#if DEBUG
			let flagOverrides = flagOverrides.value
			let overrides = flags.map { $0.isOverridable ? flagOverrides[$0] : nil }
			return zip(flags, overrides).reduce(into: [:]) { acc, override in
				acc[override.0] = override.1 ?? override.0.isEnabled
			}
			#else
			return flags.reduce(into: [:]) { acc, flag in acc[flag] = flag.isEnabled }
			#endif
		}

		return Self(
			initialize: { allFeatureFlags in
				@Dependency(\.userDefaults) var userDefaults
				flagOverrides.withValue {
					for flag in allFeatureFlags {
						$0[flag] = userDefaults.bool(forKey: flag.overrideKey)
					}
				}
			},
			isEnabled: isFlagEnabled(flag:),
			allEnabled: { flags in areFlagsEnabled(flags: flags).allSatisfy { $0.value } },
			observe: { flag in
				.init { continuation in
					continuation.yield(isFlagEnabled(flag: flag))

					let cancellable = NotificationCenter.default
						.publisher(for: .FeatureFlag.didChange)
						.filter {
							guard let objectFlag = $0.object as? FeatureFlag else { return false }
							return flag == objectFlag
						}
						.sink { _ in
							continuation.yield(isFlagEnabled(flag: flag))
						}

					continuation.onTermination = { _ in cancellable.cancel() }
				}
			},
			observeAll: { flags in
				.init { continuation in
					continuation.yield(areFlagsEnabled(flags: flags))

					let cancellable = NotificationCenter.default
						.publisher(for: .FeatureFlag.didChange)
						.filter {
							guard let objectFlag = $0.object as? FeatureFlag else { return false }
							return flags.contains(objectFlag)
						}
						.sink { _ in
							continuation.yield(areFlagsEnabled(flags: flags))
						}

					continuation.onTermination = { _ in cancellable.cancel() }
				}
			},
			setEnabled: { flag, enabled in
				guard flag.isOverridable else { return }

				flagOverrides.withValue { $0[flag] = enabled }

				@Dependency(\.userDefaults) var userDefaults
				if let enabled {
					userDefaults.setBool(forKey: flag.overrideKey, to: enabled)
				} else {
					userDefaults.remove(key: flag.overrideKey)
				}

				NotificationCenter.default.post(name: .FeatureFlag.didChange, object: flag)
			},
			resetOverrides: {
				let resetFlags = flagOverrides.withValue {
					let overriddenFlags = Array($0.keys)
					$0.removeAll()
					return overriddenFlags
				}

				@Dependency(\.userDefaults) var userDefaults
				for flag in resetFlags {
					userDefaults.remove(key: flag.overrideKey)
					NotificationCenter.default.post(name: .FeatureFlag.didChange, object: flag)
				}
			}
		)
	}
}

extension FeatureFlag {
	var overrideKey: String {
		"FeatureFlag.Override.\(name)"
	}
}

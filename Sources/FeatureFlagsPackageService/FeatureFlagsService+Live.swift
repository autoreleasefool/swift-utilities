import Combine
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
		@Dependency(\.featureFlagsQueue) var queue

		let flagManager = FeatureFlagOverrides(queue: queue)

		@Sendable func isFlagEnabled(flag: FeatureFlag) -> Bool {
			#if DEBUG
			return flagManager.getOverride(flag: flag) ?? flag.isEnabled
			#else
			return flag.isEnabled
			#endif
		}

		@Sendable func areFlagsEnabled(flags: [FeatureFlag]) -> [FeatureFlag: Bool] {
			#if DEBUG
			let overrides = flagManager.getOverrides(flags: flags)
			return zip(flags, overrides).reduce(into: [:]) { acc, override in
				acc[override.0] = override.1 ?? override.0.isEnabled
			}
			#else
			return flags.reduce(into: [:]) { acc, flag in acc[flag] = flag.isEnabled }
			#endif
		}

		return Self(
			initialize: { allFeatureFlags in
				flagManager.register(allFeatureFlags)
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
				flagManager.setOverride(forFlag: flag, enabled: enabled)
				NotificationCenter.default.post(name: .FeatureFlag.didChange, object: flag)
			},
			resetOverrides: {
				for flag in flagManager.resetOverrides() {
					NotificationCenter.default.post(name: .FeatureFlag.didChange, object: flag)
				}
			}
		)
	}
}

class FeatureFlagOverrides {
	private var allFlags: [FeatureFlag] = []

	private let queue: DispatchQueue
	private var queue_overrides: [FeatureFlag: Bool] = [:]

	init(queue: DispatchQueue) {
		self.queue = queue
	}

	func register(_ flags: [FeatureFlag]) {
		@Dependency(\.userDefaults) var userDefaults
		self.allFlags = flags
		queue.sync {
			for flag in allFlags {
				queue_overrides[flag] = userDefaults.bool(forKey: flag.overrideKey)
			}
		}
	}

	func resetOverrides() -> [FeatureFlag] {
		@Dependency(\.userDefaults) var userDefaults
		return queue.sync {
			let overridden = Array(self.queue_overrides.keys)
			queue_overrides.removeAll()
			for flag in allFlags {
				userDefaults.remove(key: flag.overrideKey)
			}
			return overridden
		}
	}

	func setOverride(forFlag flag: FeatureFlag, enabled: Bool?) {
		@Dependency(\.userDefaults) var userDefaults
		queue.async {
			guard flag.isOverridable else { return }
			self.queue_overrides[flag] = enabled
			if let enabled {
				userDefaults.setBool(forKey: flag.overrideKey, to: enabled)
			} else {
				userDefaults.remove(key: flag.overrideKey)
			}
		}
	}

	func getOverride(flag: FeatureFlag) -> Bool? {
		guard flag.isOverridable else { return nil }
		return queue.sync(flags: .barrier) { queue_overrides[flag] }
	}

	func getOverrides(flags: [FeatureFlag]) -> [Bool?] {
		queue.sync(flags: .barrier) { flags.map { $0.isOverridable ? queue_overrides[$0] : nil } }
	}
}

extension FeatureFlag {
	var overrideKey: String {
		"FeatureFlag.Override.\(name)"
	}
}

extension DependencyValues {
	var featureFlagsQueue: DispatchQueue {
		get { self[FeatureFlagsQueueKey.self]  }
		set { self[FeatureFlagsQueueKey.self] = newValue }
	}

	enum FeatureFlagsQueueKey: DependencyKey {
		static var liveValue = DispatchQueue(label: "FeatureFlagsService.FeatureFlagManager", attributes: .concurrent)
		static var testValue = DispatchQueue(label: "FeatureFlagsService.FeatureFlagManager", attributes: .concurrent)
	}
}

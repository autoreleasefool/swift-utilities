import SwiftUI

#if canImport(UIKit) && os(iOS)
extension UIApplication {
	@MainActor public var keyWindow: UIWindow? {
		connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.flatMap { $0.windows }
			.first { $0.isKeyWindow }
	}
}

public struct SafeAreaInsetsProvider {
	@MainActor public func get() -> EdgeInsets {
		UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
	}
}

private struct SafeAreaInsetsProviderKey: EnvironmentKey {
	static var defaultValue: SafeAreaInsetsProvider {
		SafeAreaInsetsProvider()
	}
}

extension EnvironmentValues {
	public var safeAreaInsetsProvider: SafeAreaInsetsProvider {
		self[SafeAreaInsetsProviderKey.self]
	}
}

#if swift(<6)
private struct SafeAreaInsetsKey: EnvironmentKey {
	@MainActor static var defaultValue: EdgeInsets {
		UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
	}
}

extension EnvironmentValues {
	@available(*, deprecated, renamed: "safeAreaInsetsProvider", message: "SafeAreaInsetsProvider offers MainActor isolated access to SafeAreaInsets")
	public var safeAreaInsets: EdgeInsets {
		self[SafeAreaInsetsKey.self]
	}
}
#endif


private extension UIEdgeInsets {
	var swiftUiInsets: EdgeInsets {
		EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
	}
}
#endif

import Dependencies
import PasteboardServiceInterface
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension PasteboardService: DependencyKey {
	public static var liveValue = Self(
		copyToClipboard: { value in
			#if canImport(UIKit)
			UIPasteboard.general.string = value
			#elseif canImport(AppKit)
			NSPasteboard.general.clearContents()
			NSPasteboard.general.setString(value, forType: .string)
			#endif
		}
	)
}

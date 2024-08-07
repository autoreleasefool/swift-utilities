import SwiftUI

extension ButtonStyle where Self == NavigationButtonStyle {
	public static var navigation: NavigationButtonStyle { .init() }
}

public struct NavigationButtonStyle: ButtonStyle {
	public func makeBody(configuration: Configuration) -> some View {
		NavigationLink {
		} label: {
			configuration.label
		}.background(content: {
#if os(iOS) || os(macOS)
			ListRowInteractor(
				isSelected: configuration.isPressed
			)
#endif
		})
	}

	#if os(iOS)
		struct ListRowInteractor: UIViewRepresentable {
			let isSelected: Bool

			func makeUIView(context: Context) -> CollectionViewCellFinder {
				CollectionViewCellFinder()
			}

			func updateUIView(_ uiView: CollectionViewCellFinder, context: Context) {
				uiView.setSelected(isSelected)
			}

			final class CollectionViewCellFinder: UIView {
				func setSelected(_ isSelected: Bool) {
					self.collectionViewCell(from: self)?.isSelected = isSelected
				}

				func collectionViewCell(from view: UIView?) -> UICollectionViewCell? {
					guard let view = view else { return nil }
					return (view as? UICollectionViewCell) ?? self.collectionViewCell(from: view.superview)
				}
			}
		}
	#elseif os(macOS)
		struct ListRowInteractor: NSViewRepresentable {
			let isSelected: Bool

			func makeNSView(context: Context) -> TableRowFinder {
				TableRowFinder()
			}

			func updateNSView(_ nsView: TableRowFinder, context: Context) {
				nsView.setSelected(isSelected)
			}

			final class TableRowFinder: NSView {
				func setSelected(_ isSelected: Bool) {
					self.tableRowView(from: self)?.isSelected = isSelected
				}

				func tableRowView(from view: NSView?) -> NSTableRowView? {
					guard let view = view else { return nil }
					return (view as? NSTableRowView) ?? self.tableRowView(from: view.superview)
				}
			}
		}
	#endif
}

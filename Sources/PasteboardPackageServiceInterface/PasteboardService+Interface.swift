import Dependencies
import DependenciesMacros

@DependencyClient
public struct PasteboardService: Sendable {
	public var copyToClipboard: @Sendable (String) async throws -> Void
}

extension PasteboardService: TestDependencyKey {
	public static var testValue = Self()
}

extension DependencyValues {
	public var pasteboard: PasteboardService {
		get { self[PasteboardService.self] }
		set { self[PasteboardService.self] = newValue }
	}
}

// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "swift-utilities",
	defaultLocalization: "en",
	platforms: [
		.iOS("17.0"),
		.macOS("14.0"),
	],
	products: [
		// MARK: - Features

		// MARK: - Repositories

		// MARK: - Data Providers

		// MARK: - Services
		.library(name: "FileManagerService", targets: ["FileManagerService"]),
		.library(name: "FileManagerServiceInterface", targets: ["FileManagerServiceInterface"]),
		.library(name: "PasteboardService", targets: ["PasteboardService"]),
		.library(name: "PasteboardServiceInterface", targets: ["PasteboardServiceInterface"]),

		// MARK: - Libraries
		.library(name: "EquatableLibrary", targets: ["EquatableLibrary"]),
		.library(name: "ExtensionsLibrary", targets: ["ExtensionsLibrary"]),
		.library(name: "SwiftUIExtensionsLibrary", targets: ["SwiftUIExtensionsLibrary"]),
	],
	dependencies: [
		.package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.2.2"),
		.package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.16.0"),
	],
	targets: [
		// MARK: - Features

		// MARK: - Repositories

		// MARK: - Data Providers

		// MARK: - Services
		.target(
			name: "FileManagerService",
			dependencies: [
				"FileManagerServiceInterface",
			]
		),
		.target(
			name: "FileManagerServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "FileManagerServiceTests",
			dependencies: [
				"FileManagerService",
			]
		),
		.target(
			name: "PasteboardService",
			dependencies: [
				"PasteboardServiceInterface",
			]
		),
		.target(
			name: "PasteboardServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "PasteboardServiceTests",
			dependencies: [
				"PasteboardService",
			]
		),

		// MARK: - Libraries
		.target(
			name: "EquatableLibrary",
			dependencies: []
		),
		.testTarget(
			name: "EquatableLibraryTests",
			dependencies: [
				"EquatableLibrary",
			]
		),
		.target(
			name: "ExtensionsLibrary",
			dependencies: []
		),
		.testTarget(
			name: "ExtensionsLibraryTests",
			dependencies: [
				"ExtensionsLibrary",
			]
		),
		.target(
			name: "SwiftUIExtensionsLibrary",
			dependencies: []
		),
		.testTarget(
			name: "SwiftUIExtensionsLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"SwiftUIExtensionsLibrary",
			]
		),
	]
)

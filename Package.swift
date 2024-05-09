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
		.library(name: "AnalyticsService", targets: ["AnalyticsService"]),
		.library(name: "AnalyticsServiceInterface", targets: ["AnalyticsServiceInterface"]),
		.library(name: "BundleService", targets: ["BundleService"]),
		.library(name: "BundleServiceInterface", targets: ["BundleServiceInterface"]),
		.library(name: "FileManagerService", targets: ["FileManagerService"]),
		.library(name: "FileManagerServiceInterface", targets: ["FileManagerServiceInterface"]),
		.library(name: "PasteboardService", targets: ["PasteboardService"]),
		.library(name: "PasteboardServiceInterface", targets: ["PasteboardServiceInterface"]),
		.library(name: "SentryErrorReportingService", targets: ["SentryErrorReportingService"]),
		.library(name: "TelemetryDeckAnalyticsService", targets: ["TelemetryDeckAnalyticsService"]),
		.library(name: "UserDefaultsService", targets: ["UserDefaultsService"]),
		.library(name: "UserDefaultsServiceInterface", targets: ["UserDefaultsServiceInterface"]),

		// MARK: - Libraries
		.library(name: "EquatableLibrary", targets: ["EquatableLibrary"]),
		.library(name: "ErrorReportingClientLibrary", targets: ["ErrorReportingClientLibrary"]),
		.library(name: "ExtensionsLibrary", targets: ["ExtensionsLibrary"]),
		.library(name: "SwiftUIExtensionsLibrary", targets: ["SwiftUIExtensionsLibrary"]),
		.library(name: "TestUtilitiesLibrary", targets: ["TestUtilitiesLibrary"]),
	],
	dependencies: [
		.package(url: "https://github.com/getsentry/sentry-cocoa.git", from: "8.21.0"),
		.package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.2.2"),
		.package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.16.0"),
		.package(url: "https://github.com/TelemetryDeck/SwiftClient.git", from: "1.5.1"),
	],
	targets: [
		// MARK: - Features

		// MARK: - Repositories

		// MARK: - Data Providers

		// MARK: - Services
		.target(
			name: "AnalyticsService",
			dependencies: [
				"AnalyticsServiceInterface",
			]
		),
		.target(
			name: "AnalyticsServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "AnalyticsServiceTests",
			dependencies: [
				"AnalyticsService",
			]
		),
		.target(
			name: "BundleService",
			dependencies: [
				"BundleServiceInterface",
			]
		),
		.target(
			name: "BundleServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
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
		.target(
			name: "SentryErrorReportingService",
			dependencies: [
				.product(name: "Sentry", package: "sentry-cocoa"),
				"ErrorReportingClientLibrary",
			]
		),
		.target(
			name: "TelemetryDeckAnalyticsService",
			dependencies: [
				.product(name: "TelemetryClient", package: "SwiftClient"),
				"AnalyticsServiceInterface",
				"BundleServiceInterface",
				"UserDefaultsServiceInterface",
			]
		),
		.testTarget(
			name: "TelemetryDeckAnalyticsServiceTests",
			dependencies: [
				"TelemetryDeckAnalyticsService",
			]
		),
		.target(
			name: "UserDefaultsService",
			dependencies: [
				"UserDefaultsServiceInterface",
			]
		),
		.target(
			name: "UserDefaultsServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "UserDefaultsServiceTests",
			dependencies: [
				"UserDefaultsService",
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
			name: "ErrorReportingClientLibrary",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
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
		.target(
			name: "TestUtilitiesLibrary",
			dependencies: []
		),
	]
)

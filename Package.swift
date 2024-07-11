// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "swift-utilities",
	defaultLocalization: "en",
	platforms: [
		.iOS("17.0"),
		.macOS("14.0"),
		.watchOS("9.0"),
	],
	products: [
		// MARK: - Features

		// MARK: - Repositories

		// MARK: - Data Providers

		// MARK: - Services
		.library(name: "AnalyticsPackageService", targets: ["AnalyticsPackageService"]),
		.library(name: "AnalyticsPackageServiceInterface", targets: ["AnalyticsPackageServiceInterface"]),
		.library(name: "AppInfoPackageService", targets: ["AppInfoPackageService"]),
		.library(name: "AppInfoPackageServiceInterface", targets: ["AppInfoPackageServiceInterface"]),
		.library(name: "BundlePackageService", targets: ["BundlePackageService"]),
		.library(name: "BundlePackageServiceInterface", targets: ["BundlePackageServiceInterface"]),
		.library(name: "FeatureFlagsPackageService", targets: ["FeatureFlagsPackageService"]),
		.library(name: "FeatureFlagsPackageServiceInterface", targets: ["FeatureFlagsPackageServiceInterface"]),
		.library(name: "FileManagerPackageService", targets: ["FileManagerPackageService"]),
		.library(name: "FileManagerPackageServiceInterface", targets: ["FileManagerPackageServiceInterface"]),
		.library(name: "GRDBDatabasePackageService", targets: ["GRDBDatabasePackageService"]),
		.library(name: "GRDBDatabasePackageServiceInterface", targets: ["GRDBDatabasePackageServiceInterface"]),
		.library(name: "PasteboardPackageService", targets: ["PasteboardPackageService"]),
		.library(name: "PasteboardPackageServiceInterface", targets: ["PasteboardPackageServiceInterface"]),
		.library(name: "SentryErrorReportingPackageService", targets: ["SentryErrorReportingPackageService"]),
		.library(name: "StoreReviewPackageService", targets: ["StoreReviewPackageService"]),
		.library(name: "StoreReviewPackageServiceInterface", targets: ["StoreReviewPackageServiceInterface"]),
		.library(name: "TelemetryDeckAnalyticsPackageService", targets: ["TelemetryDeckAnalyticsPackageService"]),
		.library(name: "UserDefaultsPackageService", targets: ["UserDefaultsPackageService"]),
		.library(name: "UserDefaultsPackageServiceInterface", targets: ["UserDefaultsPackageServiceInterface"]),

		// MARK: - Libraries
		.library(name: "EquatablePackageLibrary", targets: ["EquatablePackageLibrary"]),
		.library(name: "ErrorReportingClientPackageLibrary", targets: ["ErrorReportingClientPackageLibrary"]),
		.library(name: "ExtensionsPackageLibrary", targets: ["ExtensionsPackageLibrary"]),
		.library(name: "FeatureFlagsPackageLibrary", targets: ["FeatureFlagsPackageLibrary"]),
		.library(name: "GRDBDatabasePackageLibrary", targets: ["GRDBDatabasePackageLibrary"]),
		.library(name: "GRDBDatabaseTestUtilitiesPackageLibrary", targets: ["GRDBDatabaseTestUtilitiesPackageLibrary"]),
		.library(name: "SwiftUIExtensionsPackageLibrary", targets: ["SwiftUIExtensionsPackageLibrary"]),
		.library(name: "TestUtilitiesPackageLibrary", targets: ["TestUtilitiesPackageLibrary"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-async-algorithms.git", from: "1.0.0"),
		.package(url: "https://github.com/getsentry/sentry-cocoa.git", from: "8.21.0"),
		.package(url: "https://github.com/groue/GRDB.swift.git", from: "6.25.0"),
		.package(url: "https://github.com/pointfreeco/swift-concurrency-extras.git", from: "1.1.0"),
		.package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.2.2"),
		.package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.16.0"),
		.package(url: "https://github.com/TelemetryDeck/SwiftSDK.git", from: "2.2.1"),
	],
	targets: [
		// MARK: - Features

		// MARK: - Repositories

		// MARK: - Data Providers

		// MARK: - Services
		.target(
			name: "AnalyticsPackageService",
			dependencies: [
				"AnalyticsPackageServiceInterface",
			]
		),
		.target(
			name: "AnalyticsPackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "AnalyticsPackageServiceTests",
			dependencies: [
				"AnalyticsPackageService",
			]
		),
		.target(
			name: "AppInfoPackageService",
			dependencies: [
				"AppInfoPackageServiceInterface",
				"BundlePackageServiceInterface",
				"UserDefaultsPackageServiceInterface",
			]
		),
		.target(
			name: "AppInfoPackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "AppInfoPackageServiceTests",
			dependencies: [
				"AppInfoPackageService",
			]
		),
		.target(
			name: "BundlePackageService",
			dependencies: [
				"BundlePackageServiceInterface",
			]
		),
		.target(
			name: "BundlePackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.target(
			name: "FeatureFlagsPackageService",
			dependencies: [
				"BundlePackageServiceInterface",
				"FeatureFlagsPackageServiceInterface",
				"UserDefaultsPackageServiceInterface",
			]
		),
		.target(
			name: "FeatureFlagsPackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
				"FeatureFlagsPackageLibrary",
			]
		),
		.testTarget(
			name: "FeatureFlagsPackageServiceTests",
			dependencies: [
				"FeatureFlagsPackageService",
			]
		),
		.target(
			name: "FileManagerPackageService",
			dependencies: [
				"FileManagerPackageServiceInterface",
			]
		),
		.target(
			name: "FileManagerPackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "FileManagerPackageServiceTests",
			dependencies: [
				"FileManagerPackageService",
			]
		),
		.target(
			name: "GRDBDatabasePackageService",
			dependencies: [
				"FileManagerPackageServiceInterface",
				"GRDBDatabasePackageServiceInterface",
			]
		),
		.target(
			name: "GRDBDatabasePackageServiceInterface",
			dependencies: [
				.product(name: "ConcurrencyExtras", package: "swift-concurrency-extras"),
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
				"GRDBDatabasePackageLibrary",
			]
		),
		.testTarget(
			name: "GRDBDatabasePackageServiceTests",
			dependencies: [
				"GRDBDatabasePackageService",
				"TestUtilitiesPackageLibrary",
			]
		),
		.target(
			name: "PasteboardPackageService",
			dependencies: [
				"PasteboardPackageServiceInterface",
			]
		),
		.target(
			name: "PasteboardPackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "PasteboardPackageServiceTests",
			dependencies: [
				"PasteboardPackageService",
			]
		),
		.target(
			name: "SentryErrorReportingPackageService",
			dependencies: [
				.product(name: "Sentry", package: "sentry-cocoa"),
				"ErrorReportingClientPackageLibrary",
			]
		),
		.target(
			name: "StoreReviewPackageService",
			dependencies: [
				"AppInfoPackageServiceInterface",
				"StoreReviewPackageServiceInterface",
				"UserDefaultsPackageServiceInterface",
			]
		),
		.target(
			name: "StoreReviewPackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "StoreReviewPackageServiceTests",
			dependencies: [
				"StoreReviewPackageService",
			]
		),
		.target(
			name: "TelemetryDeckAnalyticsPackageService",
			dependencies: [
				.product(name: "TelemetryDeck", package: "SwiftSDK"),
				"AnalyticsPackageServiceInterface",
				"BundlePackageServiceInterface",
				"UserDefaultsPackageServiceInterface",
			]
		),
		.testTarget(
			name: "TelemetryDeckAnalyticsPackageServiceTests",
			dependencies: [
				"TelemetryDeckAnalyticsPackageService",
			]
		),
		.target(
			name: "UserDefaultsPackageService",
			dependencies: [
				"UserDefaultsPackageServiceInterface",
			]
		),
		.target(
			name: "UserDefaultsPackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "UserDefaultsPackageServiceTests",
			dependencies: [
				"UserDefaultsPackageService",
			]
		),

		// MARK: - Libraries
		.target(
			name: "EquatablePackageLibrary",
			dependencies: []
		),
		.testTarget(
			name: "EquatablePackageLibraryTests",
			dependencies: [
				"EquatablePackageLibrary",
			]
		),
		.target(
			name: "ErrorReportingClientPackageLibrary",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.target(
			name: "ExtensionsPackageLibrary",
			dependencies: [
				.product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
				.product(name: "ConcurrencyExtras", package: "swift-concurrency-extras"),
			]
		),
		.testTarget(
			name: "ExtensionsPackageLibraryTests",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"ExtensionsPackageLibrary",
			]
		),
		.target(
			name: "FeatureFlagsPackageLibrary",
			dependencies: []
		),
		.testTarget(
			name: "FeatureFlagsPackageLibraryTests",
			dependencies: [
				"FeatureFlagsPackageLibrary",
			]
		),
		.target(
			name: "GRDBDatabasePackageLibrary",
			dependencies: [
				.product(name: "GRDB", package: "GRDB.swift"),
			]
		),
		.testTarget(
			name: "GRDBDatabasePackageLibraryTests",
			dependencies: [
				"GRDBDatabasePackageLibrary",
			]
		),
		.target(
			name: "GRDBDatabaseTestUtilitiesPackageLibrary",
			dependencies: [
				"GRDBDatabasePackageLibrary",
			]
		),
		.target(
			name: "SwiftUIExtensionsPackageLibrary",
			dependencies: []
		),
		.testTarget(
			name: "SwiftUIExtensionsPackageLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"SwiftUIExtensionsPackageLibrary",
			]
		),
		.target(
			name: "TestUtilitiesPackageLibrary",
			dependencies: []
		),
	]
)

// swift-tools-version: 5.10

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
		.package(path: "../Harmony"),
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
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "AnalyticsPackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "AnalyticsPackageServiceTests",
			dependencies: [
				"AnalyticsPackageService",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "AppInfoPackageService",
			dependencies: [
				"AppInfoPackageServiceInterface",
				"BundlePackageServiceInterface",
				"UserDefaultsPackageServiceInterface",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "AppInfoPackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "AppInfoPackageServiceTests",
			dependencies: [
				"AppInfoPackageService",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "BundlePackageService",
			dependencies: [
				"BundlePackageServiceInterface",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "BundlePackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "FeatureFlagsPackageService",
			dependencies: [
				"BundlePackageServiceInterface",
				"FeatureFlagsPackageServiceInterface",
				"UserDefaultsPackageServiceInterface",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "FeatureFlagsPackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
				"FeatureFlagsPackageLibrary",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "FeatureFlagsPackageServiceTests",
			dependencies: [
				"FeatureFlagsPackageService",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "FileManagerPackageService",
			dependencies: [
				"FileManagerPackageServiceInterface",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "FileManagerPackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "FileManagerPackageServiceTests",
			dependencies: [
				"FileManagerPackageService",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "GRDBDatabasePackageService",
			dependencies: [
				"FileManagerPackageServiceInterface",
				"GRDBDatabasePackageServiceInterface",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "GRDBDatabasePackageServiceInterface",
			dependencies: [
				.product(name: "ConcurrencyExtras", package: "swift-concurrency-extras"),
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
				.product(name: "Harmony", package: "Harmony"),
				"GRDBDatabasePackageLibrary",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "GRDBDatabasePackageServiceTests",
			dependencies: [
				"GRDBDatabasePackageService",
				"TestUtilitiesPackageLibrary",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "PasteboardPackageService",
			dependencies: [
				"PasteboardPackageServiceInterface",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "PasteboardPackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "PasteboardPackageServiceTests",
			dependencies: [
				"PasteboardPackageService",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "SentryErrorReportingPackageService",
			dependencies: [
				.product(name: "Sentry", package: "sentry-cocoa"),
				"ErrorReportingClientPackageLibrary",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "StoreReviewPackageService",
			dependencies: [
				"AppInfoPackageServiceInterface",
				"StoreReviewPackageServiceInterface",
				"UserDefaultsPackageServiceInterface",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "StoreReviewPackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "StoreReviewPackageServiceTests",
			dependencies: [
				"StoreReviewPackageService",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "TelemetryDeckAnalyticsPackageService",
			dependencies: [
				.product(name: "TelemetryDeck", package: "SwiftSDK"),
				"AnalyticsPackageServiceInterface",
				"BundlePackageServiceInterface",
				"UserDefaultsPackageServiceInterface",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "TelemetryDeckAnalyticsPackageServiceTests",
			dependencies: [
				"TelemetryDeckAnalyticsPackageService",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "UserDefaultsPackageService",
			dependencies: [
				"UserDefaultsPackageServiceInterface",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "UserDefaultsPackageServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "UserDefaultsPackageServiceTests",
			dependencies: [
				"UserDefaultsPackageService",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),

		// MARK: - Libraries
		.target(
			name: "EquatablePackageLibrary",
			dependencies: [],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "EquatablePackageLibraryTests",
			dependencies: [
				"EquatablePackageLibrary",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "ErrorReportingClientPackageLibrary",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "ExtensionsPackageLibrary",
			dependencies: [
				.product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
				.product(name: "ConcurrencyExtras", package: "swift-concurrency-extras"),
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "ExtensionsPackageLibraryTests",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"ExtensionsPackageLibrary",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "FeatureFlagsPackageLibrary",
			dependencies: [],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "FeatureFlagsPackageLibraryTests",
			dependencies: [
				"FeatureFlagsPackageLibrary",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "GRDBDatabasePackageLibrary",
			dependencies: [
				.product(name: "GRDB", package: "GRDB.swift"),
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "GRDBDatabasePackageLibraryTests",
			dependencies: [
				"GRDBDatabasePackageLibrary",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "GRDBDatabaseTestUtilitiesPackageLibrary",
			dependencies: [
				"GRDBDatabasePackageLibrary",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "SwiftUIExtensionsPackageLibrary",
			dependencies: [],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "SwiftUIExtensionsPackageLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"SwiftUIExtensionsPackageLibrary",
			],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.target(
			name: "TestUtilitiesPackageLibrary",
			dependencies: [],
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
	]
)

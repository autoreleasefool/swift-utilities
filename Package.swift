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

		// MARK: - Libraries
		.library(name: "EquatableLibrary", targets: ["EquatableLibrary"]),
	],
	dependencies: [
	],
	targets: [
		// MARK: - Features

		// MARK: - Repositories

		// MARK: - Data Providers

		// MARK: - Services

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
	]
)

// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "PlanDoSee",
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.26.0"),
        .package(url: "https://github.com/realm/realm-swift", from: "10.50.0"),
    ]
)

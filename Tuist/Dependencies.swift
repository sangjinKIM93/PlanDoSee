import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            .remote(
                url: "https://github.com/firebase/firebase-ios-sdk.git",
                requirement: .upToNextMajor(from: "10.26.0")
            ),
            .remote(
                url: "https://github.com/realm/realm-swift.git",
                requirement: .upToNextMajor(from: "10.50.0")
            ),
        ]
    ),
    platforms: [.iOS]
)

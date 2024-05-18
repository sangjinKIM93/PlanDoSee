// swift-tools-version:5.9

import ProjectDescription

// MARK: Constants
let projectName = "PlanDoSee"
let organizationName = "ray"
let bundleID = "com.PlanDoSee"
let targetVersion = "16.0"
let version = "0.0.1"
let bundleVersion = "1"

// MARK: Struct
let project = Project(
    name: projectName,
    organizationName: organizationName,
    targets: [
        Target.target(
            name: "PlanDoSee", 
            destinations: .iOS,
            product: .app,
            bundleId: bundleID,
            deploymentTargets: .iOS(targetVersion),
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "\(version)",
                "CFBundleVersion": "\(bundleVersion)",
                "CFBundleDisplayName": "\(projectName)",
            ]),
            sources: [
                "\(projectName)/App/**",
                "\(projectName)/Core/**",
                "\(projectName)/Feature/**",
            ],
            resources: getResources(),
            entitlements: "PlanDoSee/PlanDoSee.entitlements",
            dependencies: defaultDependency(),
            settings: .settings(
                base: ["DEVELOPMENT_TEAM": "K4Z8YS9YYL"],
                configurations: [],
                defaultSettings: .recommended
            )
        )
    ]
)

private func defaultDependency() -> [TargetDependency] {
    return [
        .external(name: "FirebaseAnalytics"),
        .external(name: "FirebaseAuth"),
        .external(name: "FirebaseAuthCombine-Community"),
        .external(name: "FirebaseCrashlytics"),
        .external(name: "FirebaseFirestore"),
        .external(name: "FirebaseFirestoreSwift"),
        .external(name: "Realm"),
        .external(name: "RealmSwift"),
    ]
}

private func getResources() -> ResourceFileElements {
    return [
        "PlanDoSee/Core/Resources/GoogleService-Info.plist",
        "PlanDoSee/Core/Resources/Assets.xcassets",
        "PlanDoSee/Core/Resources/Launch Screen.storyboard",
    ]
}

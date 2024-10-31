// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MyFinanceDiaryApp",
    platforms: [
        .iOS(.v16)  // Or whichever minimum iOS version you're targeting
    ],
    products: [
        .library(
            name: "MyFinanceDiaryApp",
            targets: ["MyFinanceDiaryApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/krzysztofzablocki/Inject.git", from: "1.0.0"),
        // Add other dependencies here
    ],
    targets: [
        .target(
            name: "MyFinanceDiaryApp",
            dependencies: ["Inject"]),
        .testTarget(
            name: "MyFinanceDiaryAppTests",
            dependencies: ["MyFinanceDiaryApp"]),
    ]
) 
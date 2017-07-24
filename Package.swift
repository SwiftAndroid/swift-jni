// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "JNISwift",
    products: [
        .library(name: "JNISwift", type: .dynamic, targets: ["JNISwift"])
    ],
    targets: [
        .target(name: "JNISwift", dependencies: ["CJNI"]),
        .target(name: "CJNI", dependencies: [])
    ]
)

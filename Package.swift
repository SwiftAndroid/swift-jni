// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "JNI",
    products: [
        .library(name: "JNI", type: .dynamic, targets: ["JNI", "CJNI"])
    ],
    targets: [
        .target(name: "CJNI"),
        .target(name: "JNI", dependencies: ["CJNI"])
    ]
)

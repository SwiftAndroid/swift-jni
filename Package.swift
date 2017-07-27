// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "JNI",
    products: [
        .library(name: "JNI", type: .dynamic, targets: ["CJNI", "JNI"])
    ],
    targets: [
        .target(name: "JNI", dependencies: ["CJNI"]),
        .target(name: "CJNI")
    ]
)

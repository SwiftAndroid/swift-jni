// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "JNI",
    products: [
        .library(name: "JNI", targets: ["JNI"])
    ],
    targets: [
        .target(name: "JNI"),
    ]
)

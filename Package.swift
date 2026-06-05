// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "JNI",
    products: [
        .library(name: "JNI", targets: ["JNI"])
    ],
    targets: [
        .target(name: "JNI", swiftSettings: [.interoperabilityMode(.Cxx)]),
    ],
    swiftLanguageModes: [.v5]
)

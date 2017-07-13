// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "JNISwift",
    targets: [
        Target(name: "JNISwift", dependencies: ["CJNI"]),
        Target(name: "CJNI", dependencies: [])
    ]
)

products.append(Product(name: "JNISwift", type: .Library(.Dynamic), modules: ["JNISwift"]))

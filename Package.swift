// swift-tools-version: 6.1

import PackageDescription

let llamaVersion = "b8778"

let package = Package(
    name: "LocalLLMClient",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "LocalLLMClient", targets: ["LocalLLMClient"]),
        .library(name: "LocalLLMClientLlama", targets: ["LocalLLMClientLlama"])
    ],
    dependencies: [
        .package(url: "https://github.com/huggingface/swift-jinja", .upToNextMinor(from: "2.0.0"))
    ],
    targets: [
        .target(
            name: "LocalLLMClient",
            dependencies: ["LocalLLMClientCore"]
        ),
        .target(
            name: "LocalLLMClientCore",
            dependencies: [
                "LocalLLMClientUtility",
                .product(name: "Jinja", package: "swift-jinja")
            ]
        ),
        .target(name: "LocalLLMClientUtility"),
        .target(
            name: "LocalLLMClientLlama",
            dependencies: [
                "LocalLLMClientCore",
                "LocalLLMClientLlamaC"
            ],
            resources: [.process("Resources")],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        ),
        .binaryTarget(
            name: "LocalLLMClientLlamaFramework",
            url:
                "https://github.com/stephanbail/LocalLLMClient/releases/download/xcf-\(llamaVersion)/llama-\(llamaVersion).xcframework.zip",
            checksum: "868a6b435393d451a3cd211fe186579a596d5a512e1711f1ce7048539fdc7ae3"
        ),
        .target(
            name: "LocalLLMClientLlamaC",
            dependencies: ["LocalLLMClientLlamaFramework"],
            exclude: ["exclude"],
            cSettings: [
                .unsafeFlags(["-w"]),
                .headerSearchPath(".")
            ],
            cxxSettings: [
                .headerSearchPath(".")
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        )
    ],
    cxxLanguageStandard: .cxx17
)

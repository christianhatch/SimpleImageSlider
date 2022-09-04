// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "SimpleImageSlider",
    products: [
        .library(
            name: "SimpleImageSlider",
            targets: ["SimpleImageSlider"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SimpleImageSlider"),
        .testTarget(
            name: "SimpleImageSliderTests",
            dependencies: ["SimpleImageSlider"]),
    ]
)

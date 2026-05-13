#!/usr/bin/env swift
import AppKit
import Foundation

// Geometry synced with repo-root `pomidor.svg` (1024×1024 viewBox).
private let stemPath =
    "M655.625 309.463C650.649 327.333 642.749 348.646 624.065 364.209C547.764 427.761 447.364 405.624 402.869 364.208C385.242 347.615 376.428 327.333 371.453 309.462C363.208 279.961 366.762 255.567 366.762 255.567C366.762 255.567 396.331 251.313 429.453 263.084C440.684 267.055 452.34 272.87 463.429 281.239C469.683 237.698 498.826 208.622 509.487 199.262L513.468 196L517.448 199.262C528.111 208.623 557.254 237.698 563.508 281.239C574.595 272.871 586.253 267.057 597.483 263.084C630.606 251.313 660.174 255.567 660.174 255.567C660.174 255.567 663.871 279.962 655.625 309.463Z"
private let smilePath =
    "M680.075 368C830.47 499.37 773.334 808 512.5 808C251.666 808 194.53 499.37 344.925 368"

private let variants: [(name: String, svg: String)] = [
    ("MenuBarIdle", """
    <svg width="1024" height="1024" viewBox="0 0 1024 1024" fill="none" xmlns="http://www.w3.org/2000/svg">
    <circle cx="512" cy="561" r="256" fill="none" stroke="black" stroke-width="48"/>
    <path d="\(stemPath)" fill="none" stroke="black" stroke-width="48" stroke-miterlimit="10" stroke-linejoin="round"/>
    <path d="\(smilePath)" fill="none" stroke="black" stroke-width="48" stroke-linecap="round"/>
    </svg>
    """),
    ("MenuBarWork", """
    <svg width="1024" height="1024" viewBox="0 0 1024 1024" fill="none" xmlns="http://www.w3.org/2000/svg">
    <circle cx="512" cy="561" r="256" fill="black"/>
    <path d="\(stemPath)" fill="black" stroke="none"/>
    <path d="\(smilePath)" fill="none" stroke="white" stroke-width="52" stroke-linecap="round"/>
    </svg>
    """),
    ("MenuBarBreak", """
    <svg width="1024" height="1024" viewBox="0 0 1024 1024" fill="none" xmlns="http://www.w3.org/2000/svg">
    <circle cx="512" cy="561" r="256" fill="none" stroke="black" stroke-width="48"/>
    <path d="\(stemPath)" fill="black" stroke="black" stroke-width="36" stroke-miterlimit="10" stroke-linejoin="round"/>
    </svg>
    """),
    ("MenuBarPaused", """
    <svg width="1024" height="1024" viewBox="0 0 1024 1024" fill="none" xmlns="http://www.w3.org/2000/svg">
    <circle cx="512" cy="561" r="256" fill="black"/>
    <path d="\(stemPath)" fill="black" stroke="none"/>
    <path d="\(smilePath)" fill="none" stroke="white" stroke-width="52" stroke-linecap="round"/>
    <rect x="430" y="450" width="65" height="230" rx="32" fill="white"/>
    <rect x="530" y="450" width="65" height="230" rx="32" fill="white"/>
    </svg>
    """),
    ("MenuBarFinished", """
    <svg width="1024" height="1024" viewBox="0 0 1024 1024" fill="none" xmlns="http://www.w3.org/2000/svg">
    <circle cx="512" cy="561" r="256" fill="black"/>
    <path d="\(stemPath)" fill="black" stroke="none"/>
    <path d="M400 570L490 660L640 480" stroke="white" stroke-width="70" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
    """)
]

private func writePNG(from svgImage: NSImage, pixelWide: Int, pixelHigh: Int, to path: String) throws {
    let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: pixelWide,
        pixelsHigh: pixelHigh,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    )!
    bitmap.size = NSSize(width: pixelWide, height: pixelHigh)

    let ctx = NSGraphicsContext(bitmapImageRep: bitmap)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = ctx
    ctx.imageInterpolation = .high

    svgImage.draw(
        in: NSRect(x: 0, y: 0, width: pixelWide, height: pixelHigh),
        from: NSRect(origin: .zero, size: svgImage.size),
        operation: .sourceOver,
        fraction: 1.0
    )

    NSGraphicsContext.restoreGraphicsState()

    guard let pngData = bitmap.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "render_icons", code: 1, userInfo: [NSLocalizedDescriptionKey: "PNG encode failed for \(path)"])
    }
    try pngData.write(to: URL(fileURLWithPath: path))
}

let basePath = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : FileManager.default.currentDirectoryPath + "/Pomidor/Assets.xcassets"

let repoRoot = URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent().path
let pomidorSVG = "\(repoRoot)/pomidor.svg"

if FileManager.default.fileExists(atPath: pomidorSVG),
   let appIconData = try? Data(contentsOf: URL(fileURLWithPath: pomidorSVG)),
   let appIconImage = NSImage(data: appIconData)
{
    let appIconDir = "\(basePath)/AppIcon.appiconset"
    let appSizes: [(Int, String)] = [
        (16, "icon_16x16.png"),
        (32, "icon_32x32.png"),
        (64, "icon_64x64.png"),
        (128, "icon_128x128.png"),
        (256, "icon_256x256.png"),
        (512, "icon_512x512.png"),
        (1024, "icon_1024x1024.png")
    ]
    for (px, name) in appSizes {
        let path = "\(appIconDir)/\(name)"
        do {
            try writePNG(from: appIconImage, pixelWide: px, pixelHigh: px, to: path)
            print("Wrote \(path) (\(px)×\(px) px)")
        } catch {
            print("App icon \(name): \(error)")
        }
    }
} else {
    print("Skipping AppIcon: could not read \(pomidorSVG)")
}

for (name, svgString) in variants {
    guard let svgData = svgString.data(using: .utf8),
          let svgImage = NSImage(data: svgData) else {
        print("Failed to parse SVG for \(name)")
        continue
    }

    for scale in [1, 2] {
        let pxSize = 18 * scale
        let dir = "\(basePath)/\(name).imageset"
        let path = "\(dir)/icon@\(scale)x.png"
        try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true)

        do {
            try writePNG(from: svgImage, pixelWide: pxSize, pixelHigh: pxSize, to: path)
            print("Wrote \(path) (\(pxSize)×\(pxSize) px)")
        } catch {
            print("Failed to write \(path): \(error)")
        }
    }
}

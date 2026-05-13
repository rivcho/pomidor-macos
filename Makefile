.PHONY: generate build run clean debug distribution

generate:
	xcodegen generate

build: generate
	xcodebuild -project Pomidor.xcodeproj -scheme Pomidor -configuration Release build

debug: generate
	xcodebuild -project Pomidor.xcodeproj -scheme Pomidor -configuration Debug build

run: build
	open build/Release/Pomidor.app || open ~/Library/Developer/Xcode/DerivedData/Pomidor-*/Build/Products/Release/Pomidor.app

# Release app in dist/ plus a zip suitable for sharing. For Gatekeeper-friendly
# distribution outside your Mac, sign with Developer ID and notarize the zip.
distribution: generate
	rm -rf dist "$(CURDIR)/build/DerivedDataDist"
	mkdir -p dist
	xcodebuild -project Pomidor.xcodeproj -scheme Pomidor -configuration Release \
		-derivedDataPath "$(CURDIR)/build/DerivedDataDist" \
		build
	cp -R "$(CURDIR)/build/DerivedDataDist/Build/Products/Release/Pomidor.app" "$(CURDIR)/dist/Pomidor.app"
	@VERSION=$$(/usr/libexec/PlistBuddy -c 'Print CFBundleShortVersionString' "$(CURDIR)/dist/Pomidor.app/Contents/Info.plist"); \
	ARCH=$$(uname -m); \
	NAME="Pomidor-$$VERSION-macos-$$ARCH.zip"; \
	rm -f "$(CURDIR)/dist/$$NAME"; \
	cd "$(CURDIR)/dist" && ditto -c -k --sequesterRsrc --keepParent Pomidor.app "$$NAME"; \
	echo "Created $(CURDIR)/dist/$${NAME}"

clean:
	xcodebuild -project Pomidor.xcodeproj -scheme Pomidor clean 2>/dev/null || true
	rm -rf build dist DerivedData

.PHONY: generate build run clean debug distribution dmg

generate:
	xcodegen generate

build: generate
	xcodebuild -project Pomidor.xcodeproj -scheme Pomidor -configuration Release build

debug: generate
	xcodebuild -project Pomidor.xcodeproj -scheme Pomidor -configuration Debug build

run: build
	open build/Release/Pomidor.app || open ~/Library/Developer/Xcode/DerivedData/Pomidor-*/Build/Products/Release/Pomidor.app

# Release app in dist/: zip + DMG for sharing. DMG uses create-dmg (brew install create-dmg).
# For Gatekeeper-friendly distribution, sign with Developer ID and notarize the DMG (or zip).
distribution: generate
	rm -rf dist "$(CURDIR)/build/DerivedDataDist"
	mkdir -p dist
	xcodebuild -project Pomidor.xcodeproj -scheme Pomidor -configuration Release \
		-derivedDataPath "$(CURDIR)/build/DerivedDataDist" \
		build
	cp -R "$(CURDIR)/build/DerivedDataDist/Build/Products/Release/Pomidor.app" "$(CURDIR)/dist/Pomidor.app"
	@set -e; \
	VERSION=$$(/usr/libexec/PlistBuddy -c 'Print CFBundleShortVersionString' "$(CURDIR)/dist/Pomidor.app/Contents/Info.plist"); \
	ARCH=$$(uname -m); \
	ZIP_NAME="Pomidor-$$VERSION-macos-$$ARCH.zip"; \
	DMG_NAME="Pomidor-$$VERSION.dmg"; \
	rm -f "$(CURDIR)/dist/$$ZIP_NAME" "$(CURDIR)/dist/$$DMG_NAME"; \
	cd "$(CURDIR)/dist" && ditto -c -k --sequesterRsrc --keepParent Pomidor.app "$$ZIP_NAME"; \
	echo "Created $(CURDIR)/dist/$$ZIP_NAME"; \
	command -v create-dmg >/dev/null 2>&1 || { echo >&2 "Missing create-dmg. Install: brew install create-dmg"; exit 1; }; \
	STAGING="$(CURDIR)/dist/.dmg_staging"; \
	rm -rf "$$STAGING"; \
	mkdir -p "$$STAGING"; \
	ditto "$(CURDIR)/dist/Pomidor.app" "$$STAGING/Pomidor.app"; \
	cd "$(CURDIR)/dist" && create-dmg \
		--volname "Pomidor $$VERSION" \
		--window-pos 200 120 \
		--window-size 660 400 \
		--icon-size 110 \
		--icon "Pomidor.app" 180 185 \
		--hide-extension "Pomidor.app" \
		--app-drop-link 480 185 \
		"$$DMG_NAME" \
		"$$STAGING"; \
	rm -rf "$$STAGING"; \
	echo "Created $(CURDIR)/dist/$$DMG_NAME"

# Build only the DMG (expects dist/Pomidor.app from a prior release build).
dmg:
	@set -e; \
	test -d "$(CURDIR)/dist/Pomidor.app" || { echo >&2 "No dist/Pomidor.app — run: make distribution"; exit 1; }; \
	VERSION=$$(/usr/libexec/PlistBuddy -c 'Print CFBundleShortVersionString' "$(CURDIR)/dist/Pomidor.app/Contents/Info.plist"); \
	DMG_NAME="Pomidor-$$VERSION.dmg"; \
	command -v create-dmg >/dev/null 2>&1 || { echo >&2 "Missing create-dmg. Install: brew install create-dmg"; exit 1; }; \
	STAGING="$(CURDIR)/dist/.dmg_staging"; \
	rm -rf "$$STAGING" "$(CURDIR)/dist/$$DMG_NAME"; \
	mkdir -p "$$STAGING"; \
	ditto "$(CURDIR)/dist/Pomidor.app" "$$STAGING/Pomidor.app"; \
	cd "$(CURDIR)/dist" && create-dmg \
		--volname "Pomidor $$VERSION" \
		--window-pos 200 120 \
		--window-size 660 400 \
		--icon-size 110 \
		--icon "Pomidor.app" 180 185 \
		--hide-extension "Pomidor.app" \
		--app-drop-link 480 185 \
		"$$DMG_NAME" \
		"$$STAGING"; \
	rm -rf "$$STAGING"; \
	echo "Created $(CURDIR)/dist/$$DMG_NAME"

clean:
	xcodebuild -project Pomidor.xcodeproj -scheme Pomidor clean 2>/dev/null || true
	rm -rf build dist DerivedData

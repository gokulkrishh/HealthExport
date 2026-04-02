# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
# Generate Xcode project (required after changing project.yml)
xcodegen generate

# Build from command line
xcodebuild -project HealthExport.xcodeproj -scheme HealthExport -sdk iphoneos build
```

## Project Overview

HealthExport is a SwiftUI iOS app (iOS 26+, Swift 6) that lets users select Apple Health data categories and export them as JSON or CSV files. Uses XcodeGen for project generation from `project.yml`.

## Architecture

- **Models/** — `HealthCategory` defines 25+ HealthKit data types grouped into 6 categories (Activity, Body, Heart, Sleep, Nutrition, Workouts) including blood pressure correlation type. `ExportFormat` and `DateRange` enums.
- **Services/** — `HealthKitManager` handles HealthKit authorization and data fetching (quantity samples, category samples, workouts, blood pressure correlations). `ExportService` serializes to JSON/CSV and writes temp files.
- **Views/** — `ContentView` gates on onboarding, then shows TabView (Categories, Export, Settings). `OnboardingView` shows on first launch. `CategoryListView` shows toggleable grouped list. `ExportView` has date range picker, format picker, and share sheet. `SettingsView` has app info, privacy policy, and health permissions links.
- **HealthExportViewModel** — `@Observable` class that owns all state: onboarding, selected categories, date range, export format, and orchestrates the export flow.

## Key Details

- HealthKit entitlement is in `HealthExport.entitlements` — do NOT add Clinical Health Records or Estimate Recalibration (personal teams don't support them)
- Info.plist uses `GENERATE_INFOPLIST_FILE: YES` in build settings with INFOPLIST_KEY_ prefixed settings
- App icon has light, dark, and tinted variants in `Assets.xcassets/AppIcon.appiconset/`
- Icons are generated from SVG source files (`icon.svg`, `icon-dark.svg`, `icon-tinted.svg`) using `rsvg-convert`
- Onboarding state is persisted via `UserDefaults` key `hasCompletedOnboarding`
- Privacy policy is at `PRIVACY.md` — keep in sync with `PrivacyPolicyView.swift`
- HealthKit data types include a `.bloodPressure` case that uses `HKCorrelationType` instead of `HKQuantityType`

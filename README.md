# HealthExport

A simple iOS app to export your Apple Health data as JSON or CSV.

## Features

- Select from 20+ health data categories (steps, heart rate, sleep, workouts, and more)
- Export as JSON or CSV
- Choose date range (7 days, 30 days, 90 days, 1 year, or custom)
- Share exported files via AirDrop, Files, or any share extension
- Supports light, dark, and tinted app icons

## Requirements

- iOS 26+
- Xcode 26+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)

## Setup

```bash
# Install XcodeGen
brew install xcodegen

# Generate Xcode project
cd HealthExport
xcodegen generate

# Open in Xcode
open HealthExport.xcodeproj
```

Set your development team in **Signing & Capabilities**, then build and run.

## Health Data Categories

| Group | Categories |
|-------|-----------|
| Activity | Steps, Distance, Active Energy, Exercise Minutes, Stand Time, Flights Climbed |
| Body | Weight, Height, BMI, Body Fat % |
| Heart | Heart Rate, Resting Heart Rate, HRV, Blood Pressure |
| Sleep | Sleep Analysis |
| Nutrition | Dietary Energy, Water, Caffeine |
| Workouts | All workout types with duration and calories |

## License

MIT

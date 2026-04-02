import HealthKit

// MARK: - Category Groups

enum HealthCategoryGroup: String, CaseIterable, Identifiable {
    case activity = "Activity"
    case body = "Body"
    case heart = "Heart"
    case sleep = "Sleep"
    case nutrition = "Nutrition"
    case workouts = "Workouts"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .activity: "figure.walk"
        case .body: "figure.stand"
        case .heart: "heart.fill"
        case .sleep: "moon.zzz.fill"
        case .nutrition: "fork.knife"
        case .workouts: "figure.run"
        }
    }
}

// MARK: - Data Type

enum HealthDataType {
    case quantity(unit: HKUnit, unitName: String)
    case category
    case workout
}

// MARK: - Health Category

struct HealthCategory: Identifiable, Hashable {
    let id: String
    let name: String
    let group: HealthCategoryGroup
    let icon: String
    let sampleType: HKSampleType
    let dataType: HealthDataType

    static func == (lhs: HealthCategory, rhs: HealthCategory) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - All Categories

extension HealthCategory {
    static let allCategories: [HealthCategory] = [
        // Activity
        HealthCategory(id: "steps", name: "Steps", group: .activity, icon: "figure.walk",
                       sampleType: HKQuantityType(.stepCount),
                       dataType: .quantity(unit: .count(), unitName: "steps")),
        HealthCategory(id: "distance", name: "Distance", group: .activity, icon: "figure.walk.motion",
                       sampleType: HKQuantityType(.distanceWalkingRunning),
                       dataType: .quantity(unit: .meter(), unitName: "m")),
        HealthCategory(id: "activeEnergy", name: "Active Energy", group: .activity, icon: "flame.fill",
                       sampleType: HKQuantityType(.activeEnergyBurned),
                       dataType: .quantity(unit: .kilocalorie(), unitName: "kcal")),
        HealthCategory(id: "exerciseMinutes", name: "Exercise Minutes", group: .activity, icon: "timer",
                       sampleType: HKQuantityType(.appleExerciseTime),
                       dataType: .quantity(unit: .minute(), unitName: "min")),
        HealthCategory(id: "standTime", name: "Stand Time", group: .activity, icon: "figure.stand",
                       sampleType: HKQuantityType(.appleStandTime),
                       dataType: .quantity(unit: .minute(), unitName: "min")),
        HealthCategory(id: "flightsClimbed", name: "Flights Climbed", group: .activity, icon: "figure.stairs",
                       sampleType: HKQuantityType(.flightsClimbed),
                       dataType: .quantity(unit: .count(), unitName: "flights")),

        // Body
        HealthCategory(id: "weight", name: "Weight", group: .body, icon: "scalemass.fill",
                       sampleType: HKQuantityType(.bodyMass),
                       dataType: .quantity(unit: .gramUnit(with: .kilo), unitName: "kg")),
        HealthCategory(id: "height", name: "Height", group: .body, icon: "ruler.fill",
                       sampleType: HKQuantityType(.height),
                       dataType: .quantity(unit: .meterUnit(with: .centi), unitName: "cm")),
        HealthCategory(id: "bmi", name: "BMI", group: .body, icon: "figure.arms.open",
                       sampleType: HKQuantityType(.bodyMassIndex),
                       dataType: .quantity(unit: .count(), unitName: "")),
        HealthCategory(id: "bodyFat", name: "Body Fat %", group: .body, icon: "percent",
                       sampleType: HKQuantityType(.bodyFatPercentage),
                       dataType: .quantity(unit: .percent(), unitName: "%")),

        // Heart
        HealthCategory(id: "heartRate", name: "Heart Rate", group: .heart, icon: "heart.fill",
                       sampleType: HKQuantityType(.heartRate),
                       dataType: .quantity(unit: .count().unitDivided(by: .minute()), unitName: "BPM")),
        HealthCategory(id: "restingHeartRate", name: "Resting Heart Rate", group: .heart, icon: "heart.circle",
                       sampleType: HKQuantityType(.restingHeartRate),
                       dataType: .quantity(unit: .count().unitDivided(by: .minute()), unitName: "BPM")),
        HealthCategory(id: "hrv", name: "Heart Rate Variability", group: .heart, icon: "waveform.path.ecg",
                       sampleType: HKQuantityType(.heartRateVariabilitySDNN),
                       dataType: .quantity(unit: .secondUnit(with: .milli), unitName: "ms")),
        HealthCategory(id: "bloodPressureSystolic", name: "Blood Pressure (Systolic)", group: .heart, icon: "heart.text.clipboard",
                       sampleType: HKQuantityType(.bloodPressureSystolic),
                       dataType: .quantity(unit: .millimeterOfMercury(), unitName: "mmHg")),
        HealthCategory(id: "bloodPressureDiastolic", name: "Blood Pressure (Diastolic)", group: .heart, icon: "heart.text.clipboard",
                       sampleType: HKQuantityType(.bloodPressureDiastolic),
                       dataType: .quantity(unit: .millimeterOfMercury(), unitName: "mmHg")),

        // Sleep
        HealthCategory(id: "sleep", name: "Sleep Analysis", group: .sleep, icon: "bed.double.fill",
                       sampleType: HKCategoryType(.sleepAnalysis),
                       dataType: .category),

        // Nutrition
        HealthCategory(id: "dietaryEnergy", name: "Dietary Energy", group: .nutrition, icon: "flame",
                       sampleType: HKQuantityType(.dietaryEnergyConsumed),
                       dataType: .quantity(unit: .kilocalorie(), unitName: "kcal")),
        HealthCategory(id: "water", name: "Water", group: .nutrition, icon: "drop.fill",
                       sampleType: HKQuantityType(.dietaryWater),
                       dataType: .quantity(unit: .literUnit(with: .milli), unitName: "mL")),
        HealthCategory(id: "caffeine", name: "Caffeine", group: .nutrition, icon: "cup.and.saucer.fill",
                       sampleType: HKQuantityType(.dietaryCaffeine),
                       dataType: .quantity(unit: .gramUnit(with: .milli), unitName: "mg")),

        // Workouts
        HealthCategory(id: "workouts", name: "Workouts", group: .workouts, icon: "figure.run",
                       sampleType: HKWorkoutType.workoutType(),
                       dataType: .workout),
    ]
}

// MARK: - Health Data Point

struct HealthDataPoint: Codable {
    let category: String
    let startDate: Date
    let endDate: Date
    let value: Double
    let unit: String
    let metadata: String?
}

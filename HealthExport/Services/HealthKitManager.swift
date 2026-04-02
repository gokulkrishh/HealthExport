@preconcurrency import HealthKit

final class HealthKitManager: Sendable {
    private let healthStore = HKHealthStore()

    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestAuthorization(for categories: [HealthCategory]) async throws {
        let readTypes: Set<HKObjectType> = Set(categories.map { $0.sampleType as HKObjectType })
        try await healthStore.requestAuthorization(toShare: Set(), read: readTypes)
    }

    func fetchData(for category: HealthCategory, from startDate: Date, to endDate: Date) async throws -> [HealthDataPoint] {
        switch category.dataType {
        case .quantity(let unit, let unitName):
            return try await fetchQuantitySamples(
                type: category.sampleType as! HKQuantityType,
                unit: unit,
                unitName: unitName,
                categoryName: category.name,
                from: startDate,
                to: endDate
            )
        case .category:
            return try await fetchCategorySamples(
                type: category.sampleType as! HKCategoryType,
                categoryName: category.name,
                from: startDate,
                to: endDate
            )
        case .workout:
            return try await fetchWorkouts(from: startDate, to: endDate)
        }
    }

    // MARK: - Quantity Samples

    private func fetchQuantitySamples(
        type: HKQuantityType,
        unit: HKUnit,
        unitName: String,
        categoryName: String,
        from startDate: Date,
        to endDate: Date
    ) async throws -> [HealthDataPoint] {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, results, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let samples = (results as? [HKQuantitySample]) ?? []
                let dataPoints = samples.map { sample in
                    HealthDataPoint(
                        category: categoryName,
                        startDate: sample.startDate,
                        endDate: sample.endDate,
                        value: sample.quantity.doubleValue(for: unit),
                        unit: unitName,
                        metadata: nil
                    )
                }
                continuation.resume(returning: dataPoints)
            }
            healthStore.execute(query)
        }
    }

    // MARK: - Category Samples (Sleep)

    private func fetchCategorySamples(
        type: HKCategoryType,
        categoryName: String,
        from startDate: Date,
        to endDate: Date
    ) async throws -> [HealthDataPoint] {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, results, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let samples = (results as? [HKCategorySample]) ?? []
                let dataPoints = samples.map { sample in
                    let duration = sample.endDate.timeIntervalSince(sample.startDate) / 60.0
                    let stage = Self.sleepStageName(sample.value)

                    return HealthDataPoint(
                        category: categoryName,
                        startDate: sample.startDate,
                        endDate: sample.endDate,
                        value: duration,
                        unit: "min",
                        metadata: stage
                    )
                }
                continuation.resume(returning: dataPoints)
            }
            healthStore.execute(query)
        }
    }

    // MARK: - Workouts

    private func fetchWorkouts(from startDate: Date, to endDate: Date) async throws -> [HealthDataPoint] {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: HKWorkoutType.workoutType(),
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, results, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let workouts = (results as? [HKWorkout]) ?? []
                let dataPoints = workouts.map { workout in
                    let calories = workout.statistics(for: HKQuantityType(.activeEnergyBurned))?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                    let activityName = workout.workoutActivityType.displayName

                    return HealthDataPoint(
                        category: "Workouts",
                        startDate: workout.startDate,
                        endDate: workout.endDate,
                        value: calories,
                        unit: "kcal",
                        metadata: activityName
                    )
                }
                continuation.resume(returning: dataPoints)
            }
            healthStore.execute(query)
        }
    }

    // MARK: - Helpers

    private static func sleepStageName(_ value: Int) -> String {
        switch HKCategoryValueSleepAnalysis(rawValue: value) {
        case .inBed: "In Bed"
        case .asleepUnspecified: "Asleep"
        case .asleepCore: "Core Sleep"
        case .asleepDeep: "Deep Sleep"
        case .asleepREM: "REM Sleep"
        case .awake: "Awake"
        default: "Unknown"
        }
    }
}

// MARK: - Workout Activity Type Display Name

extension HKWorkoutActivityType {
    var displayName: String {
        switch self {
        case .running: "Running"
        case .cycling: "Cycling"
        case .walking: "Walking"
        case .swimming: "Swimming"
        case .yoga: "Yoga"
        case .hiking: "Hiking"
        case .dance: "Dance"
        case .functionalStrengthTraining: "Strength Training"
        case .traditionalStrengthTraining: "Strength Training"
        case .elliptical: "Elliptical"
        case .rowing: "Rowing"
        case .stairClimbing: "Stair Climbing"
        case .highIntensityIntervalTraining: "HIIT"
        case .coreTraining: "Core Training"
        case .flexibility: "Flexibility"
        case .mixedCardio: "Mixed Cardio"
        case .pilates: "Pilates"
        case .crossTraining: "Cross Training"
        case .cooldown: "Cooldown"
        case .basketball: "Basketball"
        case .soccer: "Soccer"
        case .tennis: "Tennis"
        case .badminton: "Badminton"
        case .tableTennis: "Table Tennis"
        case .cricket: "Cricket"
        case .golf: "Golf"
        case .martialArts: "Martial Arts"
        case .boxing: "Boxing"
        case .skatingSports: "Skating"
        case .surfingSports: "Surfing"
        case .snowSports: "Snow Sports"
        default: "Other"
        }
    }
}

import FirebaseFirestore

struct Exercise: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let imageUrl: String?
    let muscleGroups: [MuscleGroup]
    let createdBy: String
    let createdAt: Date
    let updatedAt: Date
    
    enum MuscleGroup: String, Codable, CaseIterable {
        case chest = "Göğüs"
        case back = "Sırt"
        case shoulders = "Omuz"
        case biceps = "Biceps"
        case triceps = "Triceps"
        case legs = "Bacak"
        case abs = "Karın"
    }
}

struct WorkoutPlan: Identifiable, Codable {
    let id: String
    let date: Date
    var exercises: [WorkoutExercise]
    let notes: String?
    let createdAt: Date
    
    struct WorkoutExercise: Codable, Identifiable {
        let id: String
        let exerciseId: String
        var sets: Int
        var reps: Int
        var weight: Double
    }
} 
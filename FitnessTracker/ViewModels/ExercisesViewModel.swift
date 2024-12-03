import Foundation
import FirebaseFirestore

class ExercisesViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = FirebaseManager.shared.firestore
    
    init() {
        fetchExercises()
    }
    
    func fetchExercises() {
        isLoading = true
        
        db.collection("exercises").addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.isLoading = false
                return
            }
            
            self?.exercises = snapshot?.documents.compactMap { document in
                try? document.data(as: Exercise.self)
            } ?? []
            
            self?.isLoading = false
        }
    }
    
    func filteredExercises(for muscleGroup: Exercise.MuscleGroup?) -> [Exercise] {
        guard let muscleGroup = muscleGroup else { return exercises }
        return exercises.filter { $0.muscleGroups.contains(muscleGroup) }
    }
} 
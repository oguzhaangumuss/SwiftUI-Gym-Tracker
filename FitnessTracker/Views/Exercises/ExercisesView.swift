import SwiftUI

struct ExercisesView: View {
    @StateObject private var viewModel = ExercisesViewModel()
    @State private var showingAddExercise = false
    @State private var selectedMuscleGroup: Exercise.MuscleGroup?
    
    var body: some View {
        NavigationView {
            VStack {
                // Kas grubu filtresi
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Exercise.MuscleGroup.allCases, id: \.self) { group in
                            FilterChip(title: group.rawValue,
                                     isSelected: selectedMuscleGroup == group) {
                                if selectedMuscleGroup == group {
                                    selectedMuscleGroup = nil
                                } else {
                                    selectedMuscleGroup = group
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                List(viewModel.filteredExercises(for: selectedMuscleGroup)) { exercise in
                    NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                        ExerciseRow(exercise: exercise)
                    }
                }
            }
            .navigationTitle("Egzersizler")
            .toolbar {
                Button(action: { showingAddExercise = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExercise) {
                AddExerciseView()
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(exercise.name)
                .font(.headline)
            Text(exercise.muscleGroups.map { $0.rawValue }.joined(separator: ", "))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
} 
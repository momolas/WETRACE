//
//  ExerciseListView.swift
//  WETRACE
//
//  Created by Jules on 04/01/2026.
//

import SwiftUI

struct ExerciseListView: View {
    @State private var vm = ExerciseViewModel()

    var body: some View {
        NavigationStack {
            List(vm.exercises) { exercise in
                NavigationLink(value: exercise) {
                    HStack {
                        Image(systemName: exercise.systemImage)
                            .foregroundStyle(.blue)
                            .frame(width: 30)

                        VStack(alignment: .leading) {
                            Text(exercise.title)
                                .font(.headline)
                            Text(exercise.description)
                                .font(.caption)
                                .lineLimit(1)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Exercices")
            .navigationDestination(for: Exercise.self) { exercise in
                ExerciseDetailView(exercise: exercise)
            }
        }
    }
}

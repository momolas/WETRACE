//
//  ExerciseDetailView.swift
//  WETRACE
//
//  Created by Jules on 04/01/2026.
//

import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: exercise.systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.blue)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .clipShape(.circle)

                Text(exercise.title)
                    .font(.title)
                    .bold()

                Text(exercise.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding()

                // Placeholder for specific exercise logic (timer, instructions, etc.)
                ContentUnavailableView(
                    "Instructions détaillées bientôt disponibles",
                    systemImage: "doc.text",
                    description: Text("Consultez le site Buteyko pour plus de détails.")
                )
            }
            .padding()
        }
        .navigationTitle(exercise.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

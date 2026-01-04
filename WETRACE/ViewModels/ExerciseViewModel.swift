//
//  ExerciseViewModel.swift
//  WETRACE
//
//  Created by Jules on 04/01/2026.
//

import SwiftUI
import Observation

@MainActor
@Observable
class ExerciseViewModel {
    var exercises: [Exercise] = [
        Exercise(
            title: "The Control Pause",
            description: "Mesurez votre tolérance au CO2. Retenez votre souffle après une expiration normale jusqu'au premier signe d'inconfort.",
            systemImage: "timer"
        ),
        Exercise(
            title: "Unblock the Nose",
            description: "Exercice pour déboucher le nez. Retenez votre souffle et hochez la tête de haut en bas jusqu'à un fort besoin de respirer.",
            systemImage: "cross.case"
        ),
        Exercise(
            title: "Breathing Recovery",
            description: "Petites pauses respiratoires pour calmer la respiration. Retenez votre souffle pendant 3 à 5 secondes toutes les quelques minutes.",
            systemImage: "waveform.path.ecg"
        ),
        Exercise(
            title: "Breathe Light - Relaxation",
            description: "Détendez votre corps et ralentissez votre respiration pour réduire le volume d'air inspiré.",
            systemImage: "leaf"
        ),
        Exercise(
            title: "Walking with Nasal Breathing",
            description: "Marchez en gardant la bouche fermée. Si vous devez ouvrir la bouche, ralentissez.",
            systemImage: "figure.walk"
        ),
        Exercise(
            title: "Walking with Breath Holds",
            description: "Marchez en retenant votre souffle pour augmenter la tolérance au CO2. (Avancé)",
            systemImage: "figure.run"
        ),
        Exercise(
            title: "Guided Muscle Relaxation",
            description: "Détente musculaire progressive pour réduire la tension et améliorer la respiration.",
            systemImage: "bed.double"
        )
    ]
}

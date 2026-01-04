//
//  HummingExerciseView.swift
//  WETRACE
//
//  Created by Mo on 04/01/2026.
//

import SwiftUI

struct HummingExerciseView: View {
    var isNightMode: Bool
    @State private var step: BreathStep = .inhale
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 50) {
            Text("Boost Monoxyde d'Azote")
                .font(.title)
                .bold()
                .foregroundStyle(isNightMode ? .red : .primary)
			
			Spacer()

            ZStack {
                Circle()
                    .stroke(isNightMode ? Color.red : Color.blue, lineWidth: 3)
                    .frame(width: 250, height: 250)
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .opacity(isAnimating ? 0.3 : 1.0)

                VStack {
                    Text(step.rawValue)
                        .font(.title2)
                        .bold()
                    Text("\(step.duration, format: .number.precision(.fractionLength(0)))s")
                        .font(.subheadline)
                }
                .foregroundStyle(isNightMode ? .red : .primary)
            }
			
			Spacer()

            Text("Expirez par le nez avec un bourdonnement sonore (Mmm...) pour maximiser le NO nasal.")
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundStyle(.gray)
			
			// Instructions de temps
			HStack(spacing: 20) {
				TimeIndicator(label: "In", value: "4s")
				TimeIndicator(label: "Hold", value: "4s")
				TimeIndicator(label: "Hum", value: "6s")
				TimeIndicator(label: "Rest", value: "2s")
			}
			.padding(.bottom, 50)
        }
        .onAppear {
            runAnimation()
        }
    }

    func runAnimation() {
        HapticManager.instance.triggerLight()
		withAnimation(.easeInOut(duration: step.duration)) {
			if step == .inhale { isAnimating = true }
			if step == .hum { isAnimating = false }
		}

        Task {
            try? await Task.sleep(for: .seconds(step.duration))
            step = (step == .inhale ? .hold : (step == .hold ? .hum : (step == .hum ? .pause : .inhale)))
            runAnimation()
        }
    }
}

struct TimeIndicator: View {
	var label: String
	var value: String
	var body: some View {
		VStack {
			Text(label).font(.caption).foregroundColor(.gray)
			Text(value).font(.headline)
		}
	}
}

#Preview {
	HummingExerciseView(isNightMode: true)
		.preferredColorScheme(.dark)
}

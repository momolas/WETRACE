//
//  AirMasterMainView.swift
//  WETRACE
//
//  Created by Mo on 04/01/2026.
//

import SwiftUI

struct AirMasterMainView: View {
    @State private var vm = AirMasterViewModel()
    @State private var isNightMode = false
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            (isNightMode ? Color.black : Color(.systemBackground)).ignoresSafeArea()

            TabView(selection: $selectedTab) {
                // --- ONGLET 1 : BUTEYKO ---
                Tab("Pause Contrôle", systemImage: "timer", value: 0) {
                    NavigationStack {
                        VStack(spacing: 20) {
                            if !vm.lastSevenDaysScores.isEmpty {
                                ProgressChartView(data: vm.lastSevenDaysScores, isNightMode: isNightMode)
                            }

                            Spacer()

                            VStack {
                                Text(vm.pcTimerValue, format: .number.precision(.fractionLength(1)))
                                    .font(.system(size: 80, weight: .bold, design: .monospaced))
                                    .foregroundStyle(isNightMode ? .red : (vm.pcTimerValue < 20 ? .red : (vm.pcTimerValue < 40 ? .orange : .green)))

                                Text(vm.pcTimerValue < 20 ? "Respiration excessive" : (vm.pcTimerValue < 40 ? "Zone de progrès" : "Santé optimale"))
                                    .font(.headline)
                                    .foregroundStyle(.gray)
                            }

                            Button(action: { vm.isPCRunning ? vm.stopAndSavePC() : vm.startPCTimer() }) {
                                Text(vm.isPCRunning ? "STOP" : "MESURER PC")
                                    .font(.title3)
									.fontWeight(.semibold)
                                    .frame(width: 250, height: 60)
                                    .background(isNightMode ? Color.red.opacity(0.2) : Color.blue.opacity(0.1))
                                    .foregroundStyle(isNightMode ? .red : .blue)
									.clipShape(.rect(cornerRadius: 10))
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(isNightMode ? Color.red : Color.blue, lineWidth: 2))
                            }

                            Spacer()

                            List(vm.scores.prefix(3)) { score in
                                HStack {
                                    Circle()
                                        .fill(score.statusColor)
                                        .frame(width: 8, height: 8)
                                    Text(score.formattedDate)
                                        .font(.caption2)
                                    Spacer()
                                    Text("\(score.seconds, format: .number.precision(.fractionLength(0)))s")
                                        .bold()
                                }
                                .listRowBackground(isNightMode ? Color.black : Color(.secondarySystemBackground))
                            }
                            .scrollContentBackground(.hidden)
                            .frame(height: 150)
                        }
                        .padding()
                        .navigationTitle("AirMaster PC")
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Night Mode", systemImage: isNightMode ? "moon.fill" : "sun.max.fill") {
                                    isNightMode.toggle()
                                }
                                .foregroundStyle(isNightMode ? .red : .orange)
                            }
                        }
                        .preferredColorScheme(isNightMode ? .dark : .light)
                    }
                }

                // --- ONGLET 2 : HUMMING ---
                Tab("Humming", systemImage: "waveform.path", value: 1) {
                    HummingExerciseView(isNightMode: isNightMode)
                }

                // --- ONGLET 3 : EXERCISES ---
                Tab("Exercices", systemImage: "list.bullet.clipboard", value: 2) {
                    ExerciseListView()
                }
            }
            .accentColor(isNightMode ? .red : .blue)
        }
        .onAppear {
            NotificationManager.instance.request()
            NotificationManager.instance.scheduleMorningReminder()
        }
    }
}

#Preview {
	AirMasterMainView()
}

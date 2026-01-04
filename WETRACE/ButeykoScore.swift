//
//  ButeykoScore.swift
//  WETRACE
//
//  Created by Mo on 04/01/2026.
//


import SwiftUI
import Charts
import UserNotifications
import Combine

// MARK: - 1. MODÈLES DE DONNÉES
struct ButeykoScore: Identifiable, Codable {
    var id = UUID()
    let date: Date
    let seconds: Double
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var statusColor: Color {
        if seconds < 20 { return .red }
        if seconds < 40 { return .orange }
        return .green
    }
}

enum BreathStep: String {
    case inhale = "Inspirer"
    case hold = "Retenir"
    case hum = "Bourdonner (Mmm...)"
    case pause = "Repos"
    
    var duration: Double {
        switch self {
        case .inhale: return 4.0
        case .hold: return 4.0
        case .hum: return 6.0
        case .pause: return 2.0
        }
    }
}

// MARK: - 2. GESTIONNAIRES (Haptique & Notifications)
class HapticManager {
    static let instance = HapticManager()
    func triggerLight() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    func triggerSuccess() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
}

class NotificationManager {
    static let instance = NotificationManager()
    func request() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    func scheduleMorningReminder() {
        let content = UNMutableNotificationContent()
        content.title = "🌅 Test PC du Matin"
        content.body = "C'est le moment de mesurer votre Pause de Contrôle."
        var dateComponents = DateComponents(); dateComponents.hour = 7; dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "morning_pc", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: - 3. VIEWMODEL
class AirMasterViewModel: ObservableObject {
    @Published var scores: [ButeykoScore] = []
    @Published var pcTimerValue: Double = 0.0
    @Published var isPCRunning = false
    
    private var timerCancellable: AnyCancellable?
    private var startTime: Date?

    func startPCTimer() {
        pcTimerValue = 0.0
        isPCRunning = true
        startTime = Date()
        HapticManager.instance.triggerLight()
        
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                if let start = self?.startTime {
                    self?.pcTimerValue = Date().timeIntervalSince(start)
                }
            }
    }

    func stopAndSavePC() {
        isPCRunning = false
        timerCancellable?.cancel()
        if pcTimerValue > 0 {
            let newScore = ButeykoScore(date: Date(), seconds: pcTimerValue)
            scores.insert(newScore, at: 0)
            HapticManager.instance.triggerSuccess()
        }
    }

    var lastSevenDaysScores: [ButeykoScore] {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return scores.filter { $0.date >= sevenDaysAgo }.reversed()
    }
}

// MARK: - 4. COMPOSANTS DE L'INTERFACE
struct ProgressChartView: View {
    let data: [ButeykoScore]
    var isNightMode: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("PROGRÈS HEBDOMADAIRE").font(.caption).bold().foregroundColor(.gray)
            Chart {
                RuleMark(y: .value("Objectif", 40))
                    .foregroundStyle(isNightMode ? .red.opacity(0.3) : .green.opacity(0.3))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                
                ForEach(data) { score in
                    LineMark(x: .value("Date", score.date), y: .value("Sec", score.seconds))
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(isNightMode ? .red : .blue)
                    PointMark(x: .value("Date", score.date), y: .value("Sec", score.seconds))
                        .foregroundStyle(isNightMode ? .red : score.statusColor)
                }
            }
            .frame(height: 150)
        }
        .padding()
        .background(isNightMode ? Color.white.opacity(0.05) : Color(.secondarySystemBackground))
        .cornerRadius(15)
    }
}

// MARK: - 5. VUE PRINCIPALE
struct AirMasterMainView: View {
    @StateObject var vm = AirMasterViewModel()
    @State private var isNightMode = false
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            (isNightMode ? Color.black : Color(.systemBackground)).ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                // --- ONGLET 1 : BUTEYKO ---
                NavigationView {
                    VStack(spacing: 20) {
                        if !vm.lastSevenDaysScores.isEmpty {
                            ProgressChartView(data: vm.lastSevenDaysScores, isNightMode: isNightMode)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text(String(format: "%.1f", vm.pcTimerValue))
                                .font(.system(size: 80, weight: .bold, design: .monospaced))
                                .foregroundColor(isNightMode ? .red : (vm.pcTimerValue < 20 ? .red : (vm.pcTimerValue < 40 ? .orange : .green)))
                            
                            Text(vm.pcTimerValue < 20 ? "Respiration excessive" : (vm.pcTimerValue < 40 ? "Zone de progrès" : "Santé optimale"))
                                .font(.headline).foregroundColor(.gray)
                        }
                        
                        Button(action: { vm.isPCRunning ? vm.stopAndSavePC() : vm.startPCTimer() }) {
                            Text(vm.isPCRunning ? "STOP" : "MESURER PC")
                                .font(.title3).bold()
                                .frame(width: 250, height: 60)
                                .background(isNightMode ? Color.red.opacity(0.2) : Color.blue.opacity(0.1))
                                .foregroundColor(isNightMode ? .red : .blue)
                                .overlay(RoundedRectangle(cornerRadius: 30).stroke(isNightMode ? Color.red : Color.blue, lineWidth: 2))
                        }
                        
                        Spacer()
                        
                        List(vm.scores.prefix(3)) { score in
                            HStack {
                                Circle().fill(score.statusColor).frame(width: 8, height: 8)
                                Text(score.formattedDate).font(.caption2)
                                Spacer()
                                Text("\(Int(score.seconds))s").bold()
                            }
                            .listRowBackground(isNightMode ? Color.black : Color(.secondarySystemBackground))
                        }
                        .scrollContentBackground(.hidden)
                        .frame(height: 150)
                    }
                    .padding()
                    .navigationTitle("AirMaster PC")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: { isNightMode.toggle() }) {
                                Image(systemName: isNightMode ? "moon.fill" : "sun.max.fill")
                                    .foregroundColor(isNightMode ? .red : .orange)
                            }
                        }
                    }
                    .preferredColorScheme(isNightMode ? .dark : .light)
                }
                .tabItem { Label("Pause Contrôle", systemImage: "timer") }.tag(0)
                
                // --- ONGLET 2 : HUMMING ---
                HummingExerciseView(isNightMode: isNightMode)
                .tabItem { Label("Humming", systemImage: "waveform.path") }.tag(1)
            }
            .accentColor(isNightMode ? .red : .blue)
        }
        .onAppear {
            NotificationManager.instance.request()
            NotificationManager.instance.scheduleMorningReminder()
        }
    }
}

// MARK: - 6. VUE EXERCICE HUMMING
struct HummingExerciseView: View {
    var isNightMode: Bool
    @State private var step: BreathStep = .inhale
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 50) {
            Text("Boost Monoxyde d'Azote").font(.title).bold()
                .foregroundColor(isNightMode ? .red : .primary)
            
            ZStack {
                Circle()
                    .stroke(isNightMode ? Color.red : Color.blue, lineWidth: 3)
                    .frame(width: 250, height: 250)
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .opacity(isAnimating ? 0.3 : 1.0)
                
                VStack {
                    Text(step.rawValue).font(.title2).bold()
                    Text("\(Int(step.duration))s").font(.subheadline)
                }
                .foregroundColor(isNightMode ? .red : .primary)
            }
            
            Text("Expirez par le nez avec un bourdonnement sonore (Mmm...) pour maximiser le NO nasal.")
                .font(.caption).multilineTextAlignment(.center).padding(.horizontal)
                .foregroundColor(.gray)
        }
        .onAppear { runAnimation() }
    }

    func runAnimation() {
        HapticManager.instance.triggerLight()
        withAnimation(.easeInOut(duration: step.duration)) {
            isAnimating.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + step.duration) {
            step = (step == .inhale ? .hold : (step == .hold ? .hum : (step == .hum ? .pause : .inhale)))
            runAnimation()
        }
    }
}

#Preview {
	AirMasterMainView()
}

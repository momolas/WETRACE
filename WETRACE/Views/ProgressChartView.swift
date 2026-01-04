//
//  ProgressChartView.swift
//  WETRACE
//
//  Created by Mo on 04/01/2026.
//

import SwiftUI
import Charts

struct ProgressChartView: View {
    let data: [ButeykoScore]
    var isNightMode: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("PROGRÈS HEBDOMADAIRE")
                .font(.caption)
                .bold()
                .foregroundStyle(.gray)

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
        .clipShape(.rect(cornerRadius: 15))
    }
}

//
//  SwiftCharScreen.swift
//  Cat
//
//  Created by Ray on 2024/8/25.
//

import Charts
import SwiftUI

// MARK: - SwiftCharScreen

// Reference = https://nilcoalescing.com/blog/AreaChartWithADimmingLayer/
struct SwiftCharScreen: View {
  let currentDate = Calendar.date(bySettingHour: 12, of: Date())!

  let uvData = [
    (hour: 6, uv: 0), (hour: 8, uv: 1),
    (hour: 10, uv: 4), (hour: 12, uv: 6.5),
    (hour: 14, uv: 8.2), (hour: 16, uv: 6),
    (hour: 18, uv: 1.3), (hour: 20, uv: 0),
  ]

  var currentUVData: [(date: Date, uv: Double)] {
    uvData.map { (
      date: Calendar.date(bySettingHour: $0.hour, of: currentDate)!,
      uv: $0.uv
    ) }
  }

  var body: some View {
    Chart {
      ForEach(currentUVData, id: \.date) { dataPoint in
        AreaMark(x: .value("Time of day", dataPoint.date),
                 y: .value("UV Index", dataPoint.uv))
          .interpolationMethod(.cardinal)
          .foregroundStyle(
            LinearGradient(
              colors: [.green, .yellow, .red],
              startPoint: .bottom,
              endPoint: .top
            )
            .opacity(0.5))
          .alignsMarkStylesWithPlotArea()
          .accessibilityHidden(true)

        LineMark(x: .value("Time of day", dataPoint.date),
                 y: .value("UV Index", dataPoint.uv))
          .interpolationMethod(.cardinal)
          .foregroundStyle(
            .linearGradient(
              colors: [.green, .yellow, .red],
              startPoint: .bottom,
              endPoint: .top
            ))
          .lineStyle(StrokeStyle(lineWidth: 4))
          .alignsMarkStylesWithPlotArea()
      }
    }
    .chartYAxis {
      AxisMarks(
        format: .number,
        preset: .aligned,
        values: Array(0...12))
    }
  }
}

#Preview {
  SwiftCharScreen()
}

extension Calendar {
  static func date(bySettingHour hour: Int, of date: Date) -> Date? {
    Calendar.current.date(
      bySettingHour: hour,
      minute: 0,
      second: 0,
      of: date
    )
  }
}

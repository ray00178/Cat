//
//  SwiftCharScreen.swift
//  Cat
//
//  Created by Ray on 2024/8/25.
//

import Charts
import SwiftUI

// MARK: - SwiftCharScreen

// Reference
// 1. https://nilcoalescing.com/blog/AreaChartWithADimmingLayer/
// 2. https://nilcoalescing.com/blog/FillBarMarksWithGradient/
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
    VStack(alignment: .leading) {
      Text("UV index in Christchurch throughout the day")
        .font(.headline)

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

        if let dataPoint = closestDataPoint(for: currentDate) {
          // 日期已過，用遮罩來示意
          if let firstDataPoint = currentUVData.first {
            RectangleMark(
              xStart: .value("", firstDataPoint.date),
              xEnd: .value("", dataPoint.date)
            )
            .foregroundStyle(.thickMaterial)
            .opacity(0.6)
            .accessibilityHidden(true)
            .mask {
              ForEach(currentUVData, id: \.date) { dataPoint in
                AreaMark(
                  x: .value("Time of day", dataPoint.date),
                  y: .value("UV index", dataPoint.uv),
                  series: .value("", "mask"),
                  stacking: .unstacked
                )
                .interpolationMethod(.cardinal)

                LineMark(
                  x: .value("Time of day", dataPoint.date),
                  y: .value("UV index", dataPoint.uv),
                  series: .value("", "mask")
                )
                .interpolationMethod(.cardinal)
                .lineStyle(StrokeStyle(lineWidth: 1))
              }
            }
          }

          RuleMark(x: .value("Now", dataPoint.date))
            .foregroundStyle(Color.secondary)
            .accessibilityHidden(true)

          PointMark(
            x: .value("Time of day", dataPoint.date),
            y: .value("UV index", dataPoint.uv)
          )
          .symbolSize(CGSize(width: 16, height: 16))
          .foregroundStyle(.regularMaterial)
          .accessibilityHidden(true)

          PointMark(
            x: .value("Time of day", dataPoint.date),
            y: .value("UV index", dataPoint.uv)
          )
          .symbolSize(CGSize(width: 6, height: 6))
          .foregroundStyle(.primary)
          .accessibilityHidden(true)
        }
      }
      .chartYScale(range: .plotDimension(padding: 2))
      .chartYAxis {
        // 右邊y軸 標示數字
        AxisMarks(
          format: .number,
          preset: .aligned,
          values: Array(0 ... 12)
        )

        // 左邊y軸 標示低/中/高
        AxisMarks(
          preset: .inset,
          position: .leading,
          values: [1, 3, 6, 8, 11]
        ) { value in
          AxisValueLabel(
            descriptionForUVIndex(value.as(Double.self)!)
          )
        }
      }
      .padding()
    }
  }

  func closestDataPoint(for date: Date) -> (date: Date, uv: Double)? {
    currentUVData.sorted { a, b in
      abs(date.timeIntervalSince(a.date)) < abs(date.timeIntervalSince(b.date))
    }.first
  }

  func descriptionForUVIndex(_ index: Double) -> String {
    switch index {
    case 0 ... 2: "Low"
    case 3 ... 5: "Moderate"
    case 6 ... 7: "High"
    case 8 ... 10: "Very high"
    default: "Extreme"
    }
  }
}

// MARK: - SwiftChar2Screen

struct SwiftChar2Screen: View {
  let data = [
    (month: "January", temp: 17.1),
    (month: "February", temp: 17.0),
    (month: "March", temp: 14.9),
    (month: "April", temp: 12.2),
    (month: "May", temp: 9.6),
    (month: "June", temp: 6.9),
    (month: "July", temp: 6.3),
    (month: "August", temp: 7.6),
    (month: "September", temp: 9.5),
    (month: "October", temp: 11.2),
    (month: "November", temp: 13.5),
    (month: "December", temp: 15.7),
  ]

  var body: some View {
    Chart {
      ForEach(data, id: \.month) {
        BarMark(
          x: .value("Month", String($0.month.prefix(3))),
          y: .value("Temperature", $0.temp)
        )
        .accessibilityLabel("\($0.month)")
      }
      .foregroundStyle(
        .linearGradient(
          colors: [.blue, .red],
          startPoint: .bottom,
          endPoint: .top
        )
      )
      // alignsMarkStylesWithPlotArea(), This will ensure that the start and the end points of the gradient are marked within the plot area’s bounds rather then each individual BarMark.
      .alignsMarkStylesWithPlotArea()
    }
    .padding()
  }
}

#Preview {
  SwiftChar2Screen()
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

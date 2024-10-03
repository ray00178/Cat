//
//  SunAnimationScreen.swift
//  Cat
//
//  Created by Ray on 2024/10/2.
//

import SwiftUI

// Reference = https://youtu.be/srCcM2AkSCQ?si=D71Z3ok1MuVG5zrO
struct SunAnimationScreen: View {

  let sunColor: Color = Color.orange
  let lineColor: Color = Color.yellow

  @State private var isDrawing = false
  @State private var isMoving = false

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [.white, .gray.opacity(0.5)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()

      VStack {
        ZStack {
          Divider()

          // Animation Star and End Point
          HStack {
            Circle()
              .frame(width: 10, height: 10)

            Spacer()

            Circle()
              .frame(width: 10, height: 10)
          }
          .padding(12)
          .foregroundStyle(lineColor)

          // Circle time line
          ZStack {
            Circle()
              .trim(from: 1 / 2, to: 1)
              .stroke(
                style: StrokeStyle(
                  lineWidth: 2, lineCap: .round, lineJoin: .round,
                  dash: [7, 7])
              )
              .fill(.secondary)
              .frame(width: 350, height: 350)
              .padding()

            Circle()
              .trim(from: 1 / 2, to: isDrawing ? 1 : 0.2)
              .stroke(
                style: StrokeStyle(
                  lineWidth: 2, lineCap: .round, lineJoin: .round,
                  dash: [7, 7])
              )
              .fill(lineColor)
              .frame(width: 350, height: 350)
              .padding()
              .animation(
                .easeOut.repeatCount(1).speed(0.15), value: isDrawing)
          }
          .offset(y: -5)

          // Sun icon
          Image(systemName: "sun.max.fill")
            .font(.title)
            .foregroundStyle(sunColor)
            .offset(x: -175)
            .rotationEffect(.degrees(isMoving ? 180 : 0))
            .padding(.horizontal, -12)
            .animation(.easeInOut.repeatCount(1).speed(0.15), value: isMoving)

          // Sunrise - Sunset Text
          HStack {
            Text("05:32").font(.footnote).fontWeight(.regular)
            Spacer()
            Text("19:00").font(.footnote).fontWeight(.regular)
          }
          .padding(.top, 80)

        }
        .padding(.horizontal)
      }
    }
    .navigationTitle("Sunrise")
    .navigationBarTitleDisplayMode(.inline)
    .toolbarRole(.editor)
    .toolbar(.hidden, for: .tabBar)
    .onAppear {
      isDrawing.toggle()
      isMoving.toggle()
    }
  }
}

#Preview {
  SunAnimationScreen()
}

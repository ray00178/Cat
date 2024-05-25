//
//  LEDSettingScreen.swift
//  Cat
//
//  Created by Ray on 2024/5/25.
//

import SwiftUI

// MARK: - LEDSettingScreen

struct LEDSettingScreen: View {
  private let textColors: [Color] = [
    .red, .orange, .yellow, .green, .blue, .purple,
  ]

  private let backgroundColors: [Color] = [
    .red, .orange, .yellow, .green, .blue, .purple,
  ]

  @State private var selectedTextColor: Color = .red
  @State private var selectedBackgroundColor: Color = .blue

  var body: some View {
    VStack {
      Image(.led)
        .renderingMode(.template)
        .resizable()
        .scaledToFill()
        .foregroundStyle(.blue.opacity(0.6))
        .frame(height: 300)
        .clipped()

      ScrollView {
        VStack(spacing: 8) {
          ColorSelectedView(title: "Text Color", datas: textColors, tap: { color in
            withAnimation {
              selectedTextColor = color
            }
          }, selectedColor: $selectedTextColor)

          ColorSelectedView(title: "Background Color", datas: backgroundColors, tap: { color in
            withAnimation {
              selectedBackgroundColor = color
            }
          }, selectedColor: $selectedBackgroundColor)
        }
      }
    }
    .background(.black)
    .ignoresSafeArea()
  }
}

#Preview {
  LEDSettingScreen()
}

// MARK: LEDSettingScreen.ColorSelectedView

extension LEDSettingScreen {
  struct ColorSelectedView: View {
    var title: String
    var datas: [Color]
    var tap: NormalClosure<Color>

    @Binding var selectedColor: Color

    var body: some View {
      VStack(alignment: .leading) {
        Text(title)
          .foregroundStyle(.white)
          .fontDesign(.rounded)
          .fontWeight(.medium)
          .font(.title)

        HStack {
          ForEach(datas, id: \.self) { color in
            Circle()
              .fill(color)
              .frame(width: 40)
              .padding(8)
              .overlay {
                if selectedColor == color {
                  Circle()
                    .stroke(.white, lineWidth: 2)
                }
              }
              .onTapGesture {
                tap(color)
              }
          }

          Spacer()
        }
      }
      .frame(maxWidth: .infinity)
      .padding(4)
    }
  }
}

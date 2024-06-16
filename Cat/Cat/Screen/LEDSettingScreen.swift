//
//  LEDSettingScreen.swift
//  Cat
//
//  Created by Ray on 2024/5/25.
//

import OSLog
import SwiftUI

// MARK: - LEDSettingScreen

struct LEDSettingScreen: View {
  private let textColors: [Color] = [
    .red, .orange, .yellow, .green, .blue, .purple, .white,
  ]

  private let backgroundColors: [Color] = [
    .red, .orange, .yellow, .green, .blue, .purple, .black,
  ]

  @State private var text: String = ""
  @State private var textWidth: CGFloat = .zero
  @State private var offsetX: CGFloat = .zero
  @State private var fontSize: CGFloat = 100
  @State private var selectedTextColor: Color = .red
  @State private var selectedBackgroundColor: Color = .blue

  var body: some View {
    VStack {
      ZStack {
        GeometryReader { geo in
          Image(.led)
            .renderingMode(.template)
            .resizable()
            .scaledToFill()
            .frame(width: geo.size.width, height: geo.size.height)
            .foregroundStyle(selectedBackgroundColor.opacity(0.6))
            .clipped()

          // 屬性順序重要
          Text(text)
            .font(.system(size: fontSize))
            .fontDesign(.monospaced)
            .fontWeight(.bold)
            .foregroundStyle(selectedTextColor)
            .fixedSize()
            .background {
              GeometryReader { textGeo -> Color in
                DispatchQueue.main.async {
                  let textWidth = textGeo.size.width
                  offsetX = abs(geo.size.width - textWidth) / 2
                }

                return Color.clear
              }
            }
            // .offset(x: offsetX)
            .position(y: geo.size.height / 2)
            .mask {
              Image(.led)
                .renderingMode(.template)
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
            }
        }
      }
      .frame(height: 300)

      ScrollView {
        VStack(spacing: 8) {
          InputTextView(text: $text)

          ColorSelectedView(
            selectedColor: $selectedTextColor,
            title: "Text Color",
            colors: textColors,
            tap: { color in
              withAnimation {
                selectedTextColor = color
              }
            }
          )

          ColorSelectedView(
            selectedColor: $selectedBackgroundColor,
            title: "Background Color",
            colors: backgroundColors,
            tap: { color in
              withAnimation {
                selectedBackgroundColor = color
              }
            }
          )

          TextSizeSelectedView(datas: [100, 125, 150]) { value in
            withAnimation {
              fontSize = value
            }
          }
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

// MARK: Widget

extension LEDSettingScreen {
  struct InputTextView: View {
    @Binding var text: String

    var body: some View {
      VStack(alignment: .leading) {
        Text("Input Message")
          .foregroundStyle(.white)
          .fontDesign(.rounded)
          .fontWeight(.medium)
          .font(.title)

        HStack {
          TextField("", text: $text)
            .tint(.white)
            .foregroundStyle(.white)
            .font(.title2)
            .padding()
            .overlay {
              ZStack(alignment: .leading) {
                if text.isEmpty {
                  Text("Enter Message")
                    .foregroundStyle(.white.opacity(0.5))
                    .font(.title2)
                    .padding()
                }

                RoundedRectangle(cornerRadius: 12)
                  .stroke(style: .init(lineWidth: 2))
                  .fill(.white)
              }
            }
            .padding(.trailing, 12)

          Button(
            action: {
              if text.isNotEmpty {
                // TODO: 實作LED Screen
              }
            },
            label: {
              Image(systemName: "play.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.white)
            }
          )
          .padding(.horizontal, 4)
        }
      }
      .padding(4)
    }
  }

  struct ColorSelectedView: View {
    @Binding var selectedColor: Color

    var title: String
    var colors: [Color]
    var tap: NormalClosure<Color>

    var body: some View {
      VStack(alignment: .leading) {
        Text(title)
          .foregroundStyle(.white)
          .fontDesign(.rounded)
          .fontWeight(.medium)
          .font(.title)

        ScrollView(.horizontal) {
          HStack {
            ForEach(colors, id: \.self) { color in
              Circle()
                .fill(color)
                .frame(width: 44)
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
          .padding(4)
        }
      }
      .frame(maxWidth: .infinity)
      .padding(4)
    }
  }

  struct TextSizeSelectedView: View {
    var datas: [CGFloat]
    var tap: NormalClosure<CGFloat>

    @State private var selected: CGFloat = 100

    var body: some View {
      VStack(alignment: .leading) {
        Text("Text Size")
          .foregroundStyle(.white)
          .fontDesign(.rounded)
          .fontWeight(.medium)
          .font(.title)

        HStack {
          ForEach(datas, id: \.self) { value in
            Text(value.formatted())
              .foregroundStyle(.white)
              .font(.system(size: 18, weight: .bold, design: .monospaced))
              .frame(width: 44, height: 44)
              .background {
                RoundedRectangle(cornerRadius: 100)
                  .fill(.white.opacity(0.6))
              }
              .padding(8)
              .overlay {
                if selected == value {
                  Circle()
                    .stroke(.white, lineWidth: 2)
                }
              }
              .onTapGesture {
                withAnimation {
                  selected = value
                }

                tap(value)
              }
          }

          Spacer()
        }
      }
      .frame(maxWidth: .infinity)
      .padding(8)
    }
  }
}

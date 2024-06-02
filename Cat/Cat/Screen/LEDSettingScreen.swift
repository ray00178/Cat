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
    .red, .orange, .yellow, .green, .blue, .purple, .white
  ]

  private let backgroundColors: [Color] = [
    .red, .orange, .yellow, .green, .blue, .purple, .black
  ]

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
          Text("休假中 有事不要找我")
            .font(.system(size: fontSize))
            .fontDesign(.monospaced)
            .fontWeight(.bold)
            .foregroundStyle(selectedTextColor)
            .fixedSize()
            .background {
              GeometryReader { textGeo -> Color in
                DispatchQueue.main.async {
                  textWidth = textGeo.size.width
                }

                return Color.clear
              }
            }
            .offset(x: offsetX)
            .position(y: geo.size.height / 2)
            .mask {
              Image(.led)
                .renderingMode(.template)
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
            }
            .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                offsetX = geo.size.width + textWidth
              }

              DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                  offsetX = -textWidth
                }
              }
            }
        }
      }
      .frame(height: 300)
      
//      Text("Text Width = \(textWidth)")
//        .font(.headline)
//        .foregroundStyle(.white)
      
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
          
          TextSizeSelectedView(datas: [100, 150, 200]) { value in
            fontSize = value
          }
        }
      }
    }
    .background(.black)
    .ignoresSafeArea()
  }
}

#Preview {
  LEDSettingScreen.InputTextView()
}

// MARK: Widget

extension LEDSettingScreen {
  
  struct InputTextView: View {
    
    @State private var text: String = ""
    
    var body: some View {
      VStack(alignment: .leading) {
        Text("Input Message")
          .foregroundStyle(.white)
          .fontDesign(.rounded)
          .fontWeight(.medium)
          .font(.title)
        
        HStack {
          TextField("Enter Message", text: $text)
            .tint(.white)
            .padding()
            .overlay {
              RoundedRectangle(cornerRadius: 8)
                .stroke(style: .init(lineWidth: 2))
                .fill(.red)
            }
            
          
        }
      }
      .preferredColorScheme(.dark)
    }
    
  }
  
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
        
        ScrollView(.horizontal) {
          HStack {
            ForEach(datas, id: \.self) { color in
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

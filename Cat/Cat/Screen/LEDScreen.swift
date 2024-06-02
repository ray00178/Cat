//
//  LEDScreen.swift
//  Cat
//
//  Created by Ray on 2024/5/25.
//

import SwiftUI

// Reference: https://youtu.be/DEhGTw_Z7Jc?si=6293AmvEnR8hQKQB
struct LEDScreen: View {
  
  @State private var textWidth: CGFloat = .zero
  @State private var offsetX: CGFloat = .zero
  
  @Binding var fontColor: Color
  @Binding var fontSize: CGFloat
  @Binding var background: Color
  @Binding var duration: Double
  
  var body: some View {
    ZStack {
      GeometryReader { geo in
        Image(.led)
          .renderingMode(.template)
          .resizable()
          .scaledToFill()
          .frame(width: geo.size.width, height: geo.size.height)
          .foregroundStyle(background.opacity(0.6))

        // 屬性順序重要
        Text("休假中 有事不要找我")
          .font(.system(size: fontSize))
          .fontDesign(.monospaced)
          .fontWeight(.bold)
          .foregroundStyle(fontColor)
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
          .rotationEffect(.degrees(90))
          .position(x: geo.size.width / 2)
          .mask {
            Image(.led)
              .renderingMode(.template)
              .resizable()
              .scaledToFill()
              .frame(width: geo.size.width, height: geo.size.height)
          }
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
              offsetX = geo.size.height + textWidth / 2
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                offsetX = -textWidth / 2
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
  LEDScreen(fontColor: .constant(.yellow),
            fontSize: .constant(200),
            background: .constant(.green),
            duration: .constant(5))
}

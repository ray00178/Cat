//
//  ScrollTransitionsScreen.swift
//  Cat
//
//  Created by Ray on 2024/10/10.
//

import SwiftUI

// Reference = https://youtu.be/7SuorN7yZ-w?si=NZK1YLipDNruLzo8
struct ScrollTransitionsScreen: View {
  var body: some View {
    GeometryReader { proxy in
      let size = proxy.size
      
      ScrollView(.horizontal) {
        LazyHStack(spacing: 16) {
          ForEach(0..<10) { index in
            Rectangle()
              .fill(Color(hue: (Double.random(in: 0...36) * 10) / 360,
                          saturation: 1,
                          brightness: 1))
                // Type 2
            /*.frame(width: 220 + 80)
              .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                content.offset(x: phase == .identity ? 0 : -phase.value * 80)
              }*/
              .frame(width: 200, height: size.height)
              .clipShape(RoundedRectangle(cornerRadius: 26))
            // Type 1
            /*.scrollTransition(.interactive, axis: .horizontal) { (content, phase) in
                content
                  .blur(radius: phase == .identity ? 0 : 2,
                        opaque: false)
                  .scaleEffect(phase == .identity ? 1 : 0.95)
                  .offset(y: phase == .identity ? 0 : 25)
                  .rotationEffect(.init(degrees: phase == .identity ? 0 : phase.value * 15), anchor: .bottom)
              }*/
          }
        }
        .scrollTargetLayout()
      }
      .contentMargins(.horizontal, (size.width - 200) / 2)
      .scrollClipDisabled()
      .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
      .scrollIndicators(.hidden)
    }
    .frame(height: 300)
  }
}

#Preview {
  ScrollTransitionsScreen()
}

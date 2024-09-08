//
//  ProgressAnimationScreen.swift
//  Cat
//
//  Created by Ray on 2024/9/8.
//

import SwiftUI

// Reference = https://x.com/sucodeee/status/1829853055199719656
struct ProgressAnimationScreen: View {
  @State private var trimFrom: CGFloat = 0.0
  @State private var trimTo: CGFloat = 0.0
  @State private var spin: Bool = false

  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: 20)
        .frame(width: 200, height: 200)
        .foregroundStyle(.black.opacity(0.8))

      Circle()
        .trim(from: trimFrom, to: trimTo)
        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
        .frame(width: 200, height: 200)
        .foregroundStyle(.linearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing))
        .rotationEffect(.degrees(spin ? 360 : 0))
    }
    .onAppear {
      repeatAnimation()
      
      withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
        spin.toggle()
      }
    }
  }
  
  private func repeatAnimation() {
    let newFrom = CGFloat.random(in: 0.0...0.4)
    let newTo = CGFloat.random(in: newFrom...1.0)
    
    withAnimation(.linear(duration: 1.5)) {
      trimFrom = newFrom
      trimTo = newTo
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      withAnimation(.linear(duration: 1.5)) {
        trimFrom = 0.0
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        repeatAnimation()
      }
    }
  }
}

#Preview {
  ProgressAnimationScreen()
}

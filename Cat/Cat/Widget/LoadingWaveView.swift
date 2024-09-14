//
//  LoadingWaveView.swift
//  Cat
//
//  Created by Ray on 2024/8/12.
//

import SwiftUI

// Reference = https://x.com/sucodeee/status/1819715043241410982
struct LoadingWaveView: View {
  @State private var current: Int = 0

  let colors: [Color] = [.blue, .green, .orange, .yellow, .red]

  var body: some View {
    HStack(spacing: 6) {
      
      ForEach(0..<5) { index in
        Rectangle()
          .clipShape(RoundedRectangle(cornerRadius: 20))
          .frame(width: 4, height: current == index ? 80 : 5)
          .foregroundStyle(colors[index])
          .animation(.spring(duration: 0.9), value: current)
      }
    }
    /*.onAppear {
      startAnimation()
    }*/
  }
  
  private func startAnimation() {
    /*Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
      current = (current + 1) % colors.count
    }*/
  }
}

#Preview {
  LoadingWaveView()
}

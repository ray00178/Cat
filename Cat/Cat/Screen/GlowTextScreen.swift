//
//  GlowTextScreen.swift
//  Cat
//
//  Created by Ray on 2024/8/4.
//

import SwiftUI

// Reference = https://x.com/sucodeee
struct GlowTextScreen: View, @unchecked Sendable {
  
  @State private var index: Int = 0
  
  private let colors: [Color] = [.red, .orange, .yellow,
                                 .green, .blue, .cyan,
                                 .purple]
  
  private let titles: [String] = ["Java", "Javascript", "Swift",
                                  "Kotlin", "C#", "Rust",
                                  "Python"]
  
  var body: some View {
    Text(titles[index])
      .font(.largeTitle)
      .fontWeight(.light)
      .fontDesign(.rounded)
      .contentTransition(.numericText())
      .foregroundStyle(colors[index])
      .frame(width: 250)
      .shadow(color: colors[index], radius: 5)
      .shadow(color: colors[index], radius: 5)
      .shadow(color: colors[index], radius: 50)
      .shadow(color: colors[index], radius: 100)
      .shadow(color: colors[index], radius: 200)
      .onAppear {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
          withAnimation {
            index = (index + 1) % colors.count
          }
        }
      }
  }
}

#Preview {
  GlowTextScreen()
}

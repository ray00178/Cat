//
//  LaunchScreen.swift
//  Cat
//
//  Created by Ray on 2024/4/15.
//

import SwiftUI

// MARK: - LaunchScreen

struct LaunchScreen: View {
  private let delays: [Double] = [0.0, 0.2, 0.4]

  var body: some View {
    ZStack {
      logo()
      animationTitle()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      LinearGradient(colors: [.c77E7FD, .white],
                     startPoint: .top,
                     endPoint: .bottom)
    }
    .ignoresSafeArea()
  }

  @ViewBuilder
  private func logo() -> some View {
    Image(.launchCat)
      .resizable()
      .scaledToFit()
      .frame(width: 200)
  }

  @ViewBuilder
  private func animationTitle() -> some View {
    VStack {
      Spacer()

      Image(.launchTitle)
        .resizable()
        .scaledToFit()
        .frame(width: 97)
        .padding(.bottom, 100)
    }
  }
}

#Preview {
  LaunchScreen()
}

// MARK: - AnimationTextView

struct AnimationTextView: View {
  // Reference: https://youtu.be/OA_Z6IYjm8E?si=Vunx0cXWqw1vaYh5

  @State private var show: Bool = false
  @State private var scale: Bool = false

  let title: String
  let color: Color
  let delay: Double
  let animation: Animation

  init(title: String, color: Color, delay: Double, animation: Animation) {
    self.title = title
    self.color = color
    self.delay = delay
    self.animation = animation
  }

  var body: some View {
    HStack {
      ForEach(0 ..< title.count, id: \.self) { index in
        Text(String(title[title.index(title.startIndex, offsetBy: index)]))
          .font(.system(size: 60))
          .fontDesign(.monospaced)
          .fontWeight(.medium)
          .opacity(show ? 1 : 0)
          .offset(y: show ? 0 : 80)
          .animation(animation.delay(Double(index) * 0.1 + delay), value: show)
          .foregroundColor(color)
      }
    }
    .scaleEffect(scale ? 1 : 1.2)
    .onAppear {
      show.toggle()

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
        withAnimation {
          scale.toggle()
        }
      }
    }
  }
}

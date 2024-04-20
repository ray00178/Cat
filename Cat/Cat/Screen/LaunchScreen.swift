//
//  LaunchScreen.swift
//  Cat
//
//  Created by Ray on 2024/4/15.
//

import SwiftUI

// MARK: - LaunchScreen

struct LaunchScreen: View {
  
  private let delays: [Double] = [0.0, 0.04, 0.12, 0.18, 0.25]
    
  var body: some View {
    
    ZStack {
      Image(.launchCat)
        .resizable()
        .scaledToFit()
        .frame(width: 150)
      
      VStack {
        Spacer()
        
        /*Image(.launchTitle)
          .resizable()
          .scaledToFit()
          .frame(width: 97)
          .padding(.bottom, 100)*/
        
        ZStack {
          ZStack {
            AnimationTextView(title: "Cat", color: .red, initDelay: delays[0], animation: .spring(duration: 1))
            AnimationTextView(title: "Cat", color: .orange, initDelay: delays[1], animation: .spring(duration: 1))
            AnimationTextView(title: "Cat", color: .yellow, initDelay: delays[2], animation: .spring(duration: 1))
            AnimationTextView(title: "Cat", color: .green, initDelay: delays[3], animation: .spring(duration: 1))
            AnimationTextView(title: "Cat", color: .blue, initDelay: delays[4], animation: .spring(duration: 1))
          }
          AnimationTextView(title: "Cat", color: .purple, initDelay: 0.3, animation: .spring(duration: 1))
        }
        .padding(.bottom, 40)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      LinearGradient(colors: [.white, .cA791A6], startPoint: .top, endPoint: .bottom)
    }
    .ignoresSafeArea()
  }
}

#Preview {
  LaunchScreen()
}

// MARK: - AnimationTextView

struct AnimationTextView: View {
  // Reference: https://youtu.be/OA_Z6IYjm8E?si=Vunx0cXWqw1vaYh5

  let title: String
  let color: Color
  let initDelay: Double
  let animation: Animation
  private let delay: Double = 0.1

  @State private var scale: Bool = false
  @State private var show: Bool = false

  init(title: String, color: Color, initDelay: Double, animation: Animation) {
    self.title = title
    self.color = color
    self.initDelay = initDelay
    self.animation = animation
  }

  var body: some View {
    HStack {
      ForEach(0 ..< title.count, id: \.self) { index in
        Text(String(title[title.index(title.startIndex, offsetBy: index)]))
          .fontDesign(.monospaced)
          .fontWeight(.bold)
          .font(.system(size: 80))
          .opacity(show ? 1 : 0)
          .offset(y: show ? 0 : 100)
          .animation(animation.delay(Double(index) * 0.1 + initDelay), value: show)
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

//
//  ButtonsViewPosition.swift
//  Cat
//
//  Created by Ray on 2024/7/27.
//

import SwiftUI

struct ButtonsViewPosition: View {
  @State private var position = CGPoint(x: 50, y: 50)
  @State private var color = Color.purple

  var dragGesture: some Gesture {
    DragGesture()
      .onChanged { value in
        position = value.location
        print("position onChange: \(position)")
      }
      .onEnded { _ in
        if color == Color.purple {
          color = Color.blue
        }
        else {
          color = Color.purple
        }
      }
  }

  var body: some View {
    GeometryReader { proxy in

      Rectangle()
        .fill(color)
        .frame(width: 100, height: 100)
        // position 副作用，撐滿整個空間
        .position(position)
        .gesture(dragGesture)
        .onAppear {
          let screenW: CGFloat = proxy.frame(in: .global).width
          let screenH: CGFloat = proxy.frame(in: .global).height
          position = CGPoint(x: screenW / 2, y: screenH / 2)
        }
    }
    .ignoresSafeArea()
  }
}

#Preview {
  ButtonsViewPosition()
}

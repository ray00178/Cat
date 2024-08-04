//
//  ButtonsViewOffset.swift
//  Cat
//
//  Created by Ray on 2024/7/27.
//

import SwiftUI

// MARK: - ButtonsViewOffset

struct ButtonsViewOffset: View {
  @State private var savedOffset = CGSize.zero
  @State private var dragValue = CGSize.zero
  @State private var color = Color.purple

  var offset: CGSize {
    savedOffset + dragValue
  }

  var dragGesture: some Gesture {
    DragGesture()
      .onChanged { value in
        dragValue = value.translation
        print("dragValue onChange: \(dragValue)")
      }
      .onEnded { value in
        savedOffset = savedOffset + value.translation
        dragValue = CGSize.zero
        if color == Color.purple {
          color = Color.blue
        }
        else {
          color = Color.purple
        }
      }
  }

  var body: some View {
    Rectangle()
      .fill(color)
      .frame(width: 100, height: 100)
      .offset(offset)
      .gesture(dragGesture)
  }
}

#Preview {
  ButtonsViewOffset()
}

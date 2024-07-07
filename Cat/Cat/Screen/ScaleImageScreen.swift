//
//  ScaleImageScreen.swift
//  Cat
//
//  Created by Ray on 2024/5/12.
//

import SwiftUI

// Reference: https://www.hackingwithswift.com/books/ios-swiftui/how-to-use-gestures-in-swiftui
struct ScaleImageScreen: View {
  @Environment(\.dismiss) var dismiss
  
  @State private var isDragging: Bool = false
  @State private var offset: CGSize = .zero

  @State private var scale: CGFloat = 1.0
  @State private var finalScale: CGFloat = 1.0

  @State private var rotate = Angle.zero
  @State private var finalRotate = Angle.zero

  var image: Image?

  var body: some View {
    let magnifyGesture = MagnifyGesture()
      .onChanged { value in
        scale = value.magnification
      }
      .onEnded { value in
        finalScale *= value.magnification
        scale = 1.0

        if finalScale < 1 {
          withAnimation(.smooth()) {
            finalScale = 1.0
            scale = 1.0
          }
        }

        isDragging = finalScale > 1.0

        print("When scale change, isDragging = \(isDragging)")
      }

    let rotateGesture = RotateGesture()
      .onChanged { value in
        rotate = value.rotation
      }
      .onEnded { _ in
        withAnimation(.smooth()) {
          rotate = .zero
        }
      }

    // coordinateSpace default = .local 表示
    let dragGesture = DragGesture(coordinateSpace: .global)
      .onChanged { value in
        print("dragGesture change = \(value.translation)")
        guard isDragging else { return }

        offset = value.translation
//        if scale * finalScale > 1 {
//          offset = value.translation
//        }
      }
      .onEnded { _ in
        guard isDragging else { return }

        withAnimation(.spring) {
          offset = .zero
        }
      }
    let combine = SimultaneousGesture(
      dragGesture,
      SimultaneousGesture(magnifyGesture, rotateGesture)
    )

    ZStack(alignment: .center) {
      if let image {
        image
          .resizable()
          .scaledToFit()
          .offset(offset)
          .scaleEffect(scale * finalScale)
          .rotationEffect(rotate)
          .gesture(dragGesture)
          .gesture(SimultaneousGesture(magnifyGesture, rotateGesture))
      }
    }
    .overlay(alignment: .bottomTrailing) {
      Button(action: {
        dismiss()
      }, label: {
        Image(systemName: "xmark.circle.fill")
          .padding([.bottom, .trailing], 20)
          .font(.largeTitle)
      })
    }
  }
}

#Preview {
  ScaleImageScreen()
    .preferredColorScheme(.dark)
}

//
//  ScaleImageScreen.swift
//  Cat
//
//  Created by Ray on 2024/5/12.
//

import SwiftUI

// MARK: - ScaleImageScreen

// Reference: https://www.hackingwithswift.com/books/ios-swiftui/how-to-use-gestures-in-swiftui
struct ScaleImageScreen: View {
  @Environment(\.dismiss) var dismiss

  @State private var offset: CGSize = .zero

  @State private var scale: CGFloat = 1.0
  @State private var finalScale: CGFloat = 1.0

  @State private var rotate = Angle.zero
  @State private var finalRotate = Angle.zero

  @GestureState private var dragState: CGSize = .zero

  @State private var imageSize: CGSize = .zero

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
          withAnimation(.bouncy(duration: 0.5)) {
            finalScale = 1.0
            scale = 1.0
            offset = .zero
          }
        }
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

    // coordinateSpace default = .local 表示僅視圖的座標
    let dragGesture = DragGesture(coordinateSpace: .local)
//      .updating($dragState, body: { value, state, _ in
//        state = value.translation
//      })
      .onChanged { value in
        
        print("dragGesture = \(value.translation) ; \(value.startLocation)")
        offset = value.translation
      }
      .onEnded { _ in
        withAnimation(.bouncy(duration: 0.5)) {
          if finalScale == 1 {
            offset = .zero
          } else {
            
          }
        }
      }

    GeometryReader { proxy in
      if let image {
        image
          .resizable()
          .scaledToFit()
          .scaleEffect(scale * finalScale)
          .offset(offset)
          // .rotationEffect(rotate)
          .gesture(dragGesture)
          .gesture(SimultaneousGesture(magnifyGesture, rotateGesture))
      } else {
        Image(.temple)
          .resizable()
          .scaledToFit()
          .scaleEffect(scale * finalScale, anchor: .leading)
        // .offset(dragState)
          .offset(offset)
          // .rotationEffect(rotate)
          .gesture(dragGesture)
          .gesture(SimultaneousGesture(magnifyGesture, rotateGesture))
          .onTapGesture(count: 2) { location in
            print("tap location = \(location)")

            withAnimation {
              if finalScale > 1 {
                finalScale = 1

                offset = .zero
              } else {
                let imageH: CGFloat = imageSize.height
                let screenH: CGFloat = proxy.frame(in: .global).height
                finalScale = screenH / imageH
                
                offset = CGSize(width: .zero, height: 100)
              }
            }
          }
          .background {
            GeometryReader { proxy in
              Color.clear.preference(key: ViewSizePreferenceKey.self, value: proxy.size)
            }
          }
          .onPreferenceChange(ViewSizePreferenceKey.self) { size in
            imageSize = size
          }
      }
    }
    .ignoresSafeArea()
  }
}

// MARK: - ViewSizePreferenceKey

struct ViewSizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero

  static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}

#Preview {
  ScaleImageScreen()
    .preferredColorScheme(.dark)
}

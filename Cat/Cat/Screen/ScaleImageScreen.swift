//
//  ScaleImageScreen.swift
//  Cat
//
//  Created by Ray on 2024/5/12.
//

import SwiftUI

// MARK: - ScaleImageScreen

// Reference: https://www.hackingwithswift.com/books/ios-swiftui/how-to-use-gestures-in-swiftui
// https://stackoverflow.com/questions/72399204/swiftui-what-exactly-happens-when-use-offset-and-position-modifier-simultaneou
struct ScaleImageScreen: View {
  @Environment(\.dismiss) var dismiss

  @State private var savedOffset: CGSize = .zero
  @State private var position: CGPoint = .zero
  
  @State private var scale: CGFloat = 1.0
  @State private var finalScale: CGFloat = 1.0

  @State private var rotate = Angle.zero
  @State private var finalRotate = Angle.zero

  @State private var dragValue: CGSize = .zero

  @State private var imageSize: CGSize = .zero
  @State private var anchor: UnitPoint = .center
  
  @State private var center: CGSize = .zero
  
  var image: Image?
  
  var offset: CGSize {
    savedOffset + dragValue + center
  }
  
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
            savedOffset = .zero
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
      .onChanged { value in
        print("onChanged drag = \(value.translation) ; \(value.startLocation)")
        dragValue = value.translation
      }
      .onEnded { value in
        savedOffset = savedOffset + value.translation
        dragValue = .zero
        print("onEnded drage = \(value.translation) ; \(value.startLocation)")
        withAnimation(.bouncy(duration: 0.5)) {
          if finalScale == 1 {
            savedOffset = .zero
          } else {
//            switch anchor {
//            case .topLeading, .bottomLeading:
//              if value.translation.width > 0 {
//                savedOffset.width = .zero
//              }
//              // x軸位移計算 = 放大後圖片寬度 - 螢幕寬度 (待處理)
//              if abs(savedOffset.width) > (1179-393) {
//                savedOffset.width = -(abs(savedOffset.width)-393)
//              }
//              
//              //savedOffset.height = .zero
//            case .topTrailing, .bottomTrailing:
//              break
//            default:
//              break
//            }
//            print("savedOffset = \(savedOffset)")
            
          }
          
        }
      }
    ZStack {
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
            .scaleEffect(scale * finalScale, anchor: anchor)
          //.position(position)
            .offset(offset)
          // .rotationEffect(rotate)
            .gesture(dragGesture)
            .gesture(SimultaneousGesture(magnifyGesture, rotateGesture))
            .onTapGesture(count: 2) { location in
              if finalScale == 1 {
                let midX: Double = (imageSize.width / 2)
                let maxX: Double = imageSize.width
                let midY: Double = (imageSize.height / 2)
                let maxY: Double = imageSize.height
                
                // Range 0 ~ 1
                anchor = .init(x: location.x / maxX, y: (location.y - imageSize.height) / maxY)
              }
              
              withAnimation {
                if finalScale > 1 {
                  finalScale = 1
                  savedOffset = .zero
                } else {
                  let imageW: CGFloat = imageSize.width
                  let imageH: CGFloat = imageSize.height
                  let screenH: CGFloat = proxy.frame(in: .global).height
                  finalScale = screenH / imageH
                  // 計算放大後的寬度與高度
                  print("tap after = \(location) ; \(imageH) ; \(screenH) ; \(finalScale)")
                  
                  savedOffset.height = (screenH - location.y)
                  
                  // 處理放大後要位移的距離
                  // 852
                  // 3.252111653924935
                  // 190.3333282470703 * 3.252111653924935
                  // 233.0147650774
                  //savedOffset.height = screenH - imageH
                  
                  //let bottom = imageH + abs(((imageH - location.y) * finalScale))
                  //savedOffset.height = screenH - bottom
                  //print("offsetY = \(savedOffset.height)")
                }
              }
            }
            .overlay {
              GeometryReader { proxy2 in
                Color.clear.preference(key: ViewSizePreferenceKey.self, value: proxy2.size)
              }
            }
            .onPreferenceChange(ViewSizePreferenceKey.self) { size in
              imageSize = size
              
              let screenW: CGFloat = proxy.frame(in: .global).width
              let screenH: CGFloat = proxy.frame(in: .global).height
              
              center = CGSize(width: (screenW - imageSize.width)/2,
                              height: (screenH - imageSize.height)/2)
            }
        }
      }
      
      Rectangle()
        .foregroundStyle(.clear)
        .border(Color.yellow, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
    .ignoresSafeArea()
  }
}

// Convenience operator overload
func + (lhs: CGSize, rhs: CGSize) -> CGSize {
  CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}

// MARK: - ViewSizePreferenceKey

struct ViewSizePreferenceKey: PreferenceKey {
  static let defaultValue: CGSize = .zero

  static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}

#Preview {
  ScaleImageScreen()
    .preferredColorScheme(.dark)
}

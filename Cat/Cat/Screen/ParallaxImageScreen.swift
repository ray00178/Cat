//
//  ParallaxImageScreen.swift
//  Cat
//
//  Created by Ray on 2024/7/24.
//

import SwiftUI

// Reference: https://x.com/AlbertMoral/status/1813288070906802492
struct ParallaxImageScreen: View {
  @State private var resources: [ImageResource] = [
    .image1Min, .image2Min, .image3Min,
  ]

  @State private var position: CGPoint = .zero

  var body: some View {
    Text("Parallax")
      .foregroundStyle(.black.secondary)
      .bold()
      .fontDesign(.rounded)
      .font(.largeTitle)
    
    ScrollView(.horizontal) {
      LazyHStack(spacing: 16) {
        ForEach(resources, id: \.self) { resource in
          ZStack {
            Image(resource)
              .resizable()
              .scaledToFill()
              .scrollTransition(axis: .horizontal) { content, phaes in
                content.offset(x: phaes.value * -250)
              }
          }
          .containerRelativeFrame([.horizontal, .vertical])
          .clipShape(RoundedRectangle(cornerRadius: 20))
        }
      }
    }
    .frame(height: 200)
    .contentMargins(.horizontal, 20)
    .scrollIndicators(.hidden)
  }
}

#Preview {
  ParallaxImageScreen()
}

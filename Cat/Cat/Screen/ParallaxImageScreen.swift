//
//  ParallaxImageScreen.swift
//  Cat
//
//  Created by Ray on 2024/7/24.
//

import SwiftUI

// Reference: https://x.com/AlbertMoral/status/1813288070906802492
struct ParallaxImageScreen: View {
  
  @Binding var path: [Category]
  
  @State private var resources: [ImageResource] = [
    .image1Min, .image2Min, .image3Min,
  ]

  @State private var position: CGPoint = .zero

  init(path: Binding<[Category]>) {
    _path = path
  }
  
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
    .navigationTitle("Parallax Image")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(true)
    .toolbar(.hidden, for: .tabBar)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button(action: {
          path.removeLast()
        }, label: {
          Image(systemName: "arrow.left")
            .tint(.c374957)
        })
      }
    }
  }
}

#Preview {
  NavigationStack {
    ParallaxImageScreen(path: .constant(.init()))
  }
}

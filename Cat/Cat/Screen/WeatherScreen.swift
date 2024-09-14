//
//  WeatherScreen.swift
//  Cat
//
//  Created by Ray on 2024/4/26.
//

import SwiftUI

struct WeatherScreen: View {
  
  @State private var start: Bool = false
  @State private var item: String?
  
  var body: some View {
    ScrollView {
      LazyVStack {
        ForEach(0 ..< 100) { index in
          Text("\(index)")
            .font(.largeTitle)
            .fontDesign(.monospaced)
            .onTapGesture {
              start.toggle()
            }
            .fullScreenCover(isPresented: $start) {
              ZoomImageScreen(uiImage: UIImage(resource: .temple))
                .ignoresSafeArea()
            }
            .id(index)
          
          Divider()
        }
      }
      .scrollTargetLayout()
      .background(.cyan)
    }
    //.scrollTargetBehavior(.viewAligned)
    .scrollPosition(id: $item, anchor: .bottom)
    .onChange(of: item) { oldValue, newValue in
      print("onChange \(oldValue) ; \(newValue)")
    }
  }
}

#Preview {
  WeatherScreen()
}

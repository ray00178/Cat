//
//  WeatherScreen.swift
//  Cat
//
//  Created by Ray on 2024/4/26.
//

import SwiftUI

struct WeatherScreen: View {
  
  @State private var start: Bool = false
  
  var body: some View {
    ScrollView {
      ForEach(0 ..< 20) { index in
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

        Divider()
      }
      .background(.cyan)
    }
  }
}

#Preview {
  WeatherScreen()
}

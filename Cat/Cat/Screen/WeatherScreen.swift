//
//  WeatherScreen.swift
//  Cat
//
//  Created by Ray on 2024/4/26.
//

import SwiftUI

struct WeatherScreen: View {
  var body: some View {
    ScrollView {
      ForEach(0 ..< 20) { index in
        Text("\(index)")
          .font(.largeTitle)
          .fontDesign(.monospaced)

        Divider()
      }
      .background(.cyan)
    }
    //.background(.red.opacity(0.5))
  }
}

#Preview {
  WeatherScreen()
}

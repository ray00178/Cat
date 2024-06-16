//
//  AppScreen.swift
//  Cat
//
//  Created by Ray on 2024/4/13.
//

import SwiftUI

struct AppScreen: View {
  
  @State private var showing: Bool = false
  @State private var tab: Tab = .weather
  
  var body: some View {
    TabView(selection: $tab) {
      CatScreen()
        .tabItem {
          Image(.tabGrid)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
          Text("Cat")
        }
        .tag(Tab.grid)
      
      WeatherScreen()
        .tabItem {
          Image(.tabWeather)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
          Text("Weather")
        }
        .tag(Tab.weather)
      
      LEDSettingScreen()
        .tabItem {
          Image(.tabWeather)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
          Text("LED")
        }
        .tag(Tab.led)
    }
    .tint(.c050505)
    .foregroundStyle(.white)
  }
}

#Preview {
  AppScreen()
    .environmentObject(APIManager.shared)
}

// MARK: AppScreen.Tab

extension AppScreen {
  enum Tab {
    
    case grid
    
    case weather
    
    case led
  }
}

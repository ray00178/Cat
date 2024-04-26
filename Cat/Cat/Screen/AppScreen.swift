//
//  AppScreen.swift
//  Cat
//
//  Created by Ray on 2024/4/13.
//

import SwiftUI

struct AppScreen: View {
  
  @State private var tab: Tab = .cat
  
  var body: some View {
    TabView(selection: $tab) {
      CatScreen()
        .tabItem {
          Image(.tabCat)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
          Text("Cat")
        }
        .tag(Tab.cat)
      
      WeatherScreen()
        .tabItem {
          Image(.tabWeather)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
          Text("Weather")
        }
        .tag(Tab.weather)
    }
    .tint(.c050505)
  }
}

#Preview {
  AppScreen()
    .environmentObject(APIManager.shared)
}

// MARK: AppScreen.Tab

extension AppScreen {
  enum Tab {
    
    case cat
    
    case weather
  }
}

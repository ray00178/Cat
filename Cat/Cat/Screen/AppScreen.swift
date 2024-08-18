//
//  AppScreen.swift
//  Cat
//
//  Created by Ray on 2024/4/13.
//

import SwiftUI

// MARK: - AppScreen

struct AppScreen: View {
  @State private var showing: Bool = false
  @State private var currentTab: Tab = .weather
  @State private var isHiddenTabBar: Bool = true

  private let tabs: [Tab] = Tab.allCases

  var body: some View {
    originTabView()
  }

  @MainActor
  @ViewBuilder
  private func originTabView() -> some View {
    TabView(selection: $currentTab) {
      CatScreen()
        .tabItem {
          Image(.tabFire)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
          Text(Tab.fire.title)
        }
        .tag(Tab.fire)
        // Reference = https://www.kodeco.com/books/swiftui-cookbook/v1.0/chapters/2-customize-tab-view-appearance-in-swiftui
        .toolbarBackground(.white, for: .tabBar)

      WeatherScreen()
        .tabItem {
          Image(.tabWeather)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
          Text(Tab.weather.title)
        }
        .tag(Tab.weather)
        .toolbarBackground(.white, for: .tabBar)

      DemoScreen()
        .tabItem {
          Image(.tabDemo)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
          Text(Tab.demo.title)
        }
        .tag(Tab.demo)
        .toolbarBackground(.white, for: .tabBar)
    }
    .tint(.c374957)
  }
}

#Preview {
  AppScreen()
    .environmentObject(APIManager.shared)
}

// MARK: - Tab

enum Tab: CaseIterable, Hashable {
  case fire

  case weather

  case demo

  /// 標題
  var title: String {
    switch self {
    case .fire: "Cat"
    case .weather: "Weather"
    case .demo: "Demo"
    }
  }

  /// 圖檔
  var image: ImageResource {
    switch self {
    case .fire: .tabFire
    case .weather: .tabWeather
    case .demo: .tabDemo
    }
  }
}

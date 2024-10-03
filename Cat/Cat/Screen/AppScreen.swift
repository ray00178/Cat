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
  @State private var currentTab: AppTab = .weather
  @State private var isHiddenTabBar: Bool = true

  var body: some View {
    originTabView()
  }

  @ViewBuilder
  private func originTabView() -> some View {
    TabView(selection: $currentTab) {
      ForEach(AppTab.allCases) { tab in
        tab.destination
          .tabItem {
            tab.icon
          }
          .tag(tab.id)
          // // Reference = https://www.kodeco.com/books/swiftui-cookbook/v1.0/chapters/2-customize-tab-view-appearance-in-swiftui
          .toolbarBackground(.white, for: .tabBar)
      }
    }
    .tint(.c374957)
    .environment(CatRepository(apiManager: APIManager.shared))
  }
}

#Preview {
  AppScreen()
}

// MARK: - AppTab

enum AppTab: Hashable, CaseIterable, Identifiable {
  case fire

  case weather

  case demo

  var id: AppTab { self }
}

extension AppTab {
  var title: String {
    switch self {
    case .fire:
      "Cat"
    case .weather:
      "Weather"
    case .demo:
      "Demo"
    }
  }

  var image: ImageResource {
    switch self {
    case .fire:
      .tabFire
    case .weather:
      .tabWeather
    case .demo:
      .tabDemo
    }
  }

  @ViewBuilder
  var icon: some View {
    Label {
      Text(self.title)
    } icon: {
      Image(self.image)
        .renderingMode(.template)
        .resizable()
        .scaledToFit()
    }
  }

  @MainActor
  @ViewBuilder
  var destination: some View {
    switch self {
    case .fire:
      CatScreen()
    case .weather:
      WeatherScreen()
    case .demo:
      DemoScreen()
    }
  }
}

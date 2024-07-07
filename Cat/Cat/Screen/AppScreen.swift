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
    //customTabView()
    originTabView()
  }
  
  @MainActor
  @ViewBuilder
  private func customTabView() -> some View {
    VStack(spacing: 0) {
      TabView(selection: $currentTab) {
        CatScreen()
          .tabItem {
            Image(.tabGrid)
              .renderingMode(.template)
              .resizable()
              .scaledToFit()
            Text("Cat")
          }
          .tag(Tab.grid)
          .toolbar(.hidden, for: .tabBar)
        
        WeatherScreen()
          .tabItem {
            Image(.tabWeather)
              .renderingMode(.template)
              .resizable()
              .scaledToFit()
            Text("Weather")
          }
          .tag(Tab.weather)
          .toolbar(.hidden, for: .tabBar)
        
        LEDSettingScreen()
          .tabItem {
            Image(.tabLed)
              .renderingMode(.template)
              .resizable()
              .scaledToFit()
            Text("LED")
          }
          .tag(Tab.led)
          .toolbar(.hidden, for: .tabBar)
      }
      
      customTabBar()
        .frame(height: 58)
    }
  }
  
  @MainActor
  @ViewBuilder
  private func originTabView() -> some View {
    TabView(selection: $currentTab) {
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
          Image(.tabLed)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
          Text("LED")
        }
        .tag(Tab.led)
    }
    .tint(.c050505)
  }

  @ViewBuilder
  private func customTabBar() -> some View {
    HStack {
      ForEach(tabs, id: \.self) { tab in
        Spacer()

        VStack {
          Image(tab.image)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 30)
            .padding(.top, 10)
          // Reference: https://developer.apple.com/design/human-interface-guidelines/typography
          Text(tab.title)
            .font(.footnote)
        }
        .foregroundStyle(
          currentTab == tab ? .c050505 : .gray.opacity(0.5)
        )
        .onTapGesture {
          currentTab = tab
        }

        Spacer()
      }
    }
    .frame(maxWidth: .infinity)
    .background {
      UnevenRoundedRectangle(
        topLeadingRadius: 24,
        bottomLeadingRadius: 0,
        bottomTrailingRadius: 0,
        topTrailingRadius: 24
      )
      .ignoresSafeArea()
      .shadow(color:/*@START_MENU_TOKEN@*/ .black/*@END_MENU_TOKEN@*/ .opacity(0.2), radius: 4, y: -2)
      .foregroundStyle(.white)
    }
  }
}

#Preview {
  AppScreen()
    .environmentObject(APIManager.shared)
}

// MARK: - Tab

enum Tab: CaseIterable, Hashable {
  case grid

  case weather

  case led

  /// 標題
  var title: String {
    switch self {
    case .grid: "Cat"
    case .weather: "Weather"
    case .led: "LED"
    }
  }

  /// 圖檔
  var image: ImageResource {
    switch self {
    case .grid: .tabGrid
    case .weather: .tabWeather
    case .led: .tabLed
    }
  }
}

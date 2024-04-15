//
//  AppView.swift
//  Cat
//
//  Created by Ray on 2024/4/13.
//

import SwiftUI

struct AppView: View {
  
  @State private var tab: Tab = .cat
  
  var body: some View {
    TabView(selection: $tab) {
      CatScreen()
        .tabItem {
          Image(.tabCat)
            .renderingMode(.template)
          Text("Cat")
        }
        .tag(Tab.cat)
    }
    .tint(Color(._050505))
  }
}

#Preview {
  AppView()
    .environmentObject(APIManager.shared)
}

// MARK: AppView.Tab

extension AppView {
  enum Tab {
    
    case cat
    
    case profile
  }
}

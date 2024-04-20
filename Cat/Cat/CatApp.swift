//
//  CatApp.swift
//  Cat
//
//  Created by Ray on 2024/4/13.
//

import SwiftUI

@main
struct CatApp: App {
  @State private var starAnimation: Bool = false

  var body: some Scene {
    WindowGroup {
      ZStack {
        if starAnimation {
          LaunchScreen()
        } else {
          AppScreen()
            .environmentObject(APIManager.shared)
        }
      }
      .onAppear {
        starAnimation.toggle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
          withAnimation {
            starAnimation.toggle()
          }
        }
      }
    }
  }
}

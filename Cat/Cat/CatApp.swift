//
//  CatApp.swift
//  Cat
//
//  Created by Ray on 2024/4/13.
//

import SwiftUI

@main
struct CatApp: App {
  @State private var starLaunch: Bool = true
  @State private var showing: Bool = true
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        if starLaunch {
          LaunchScreen()
            .opacity(showing ? 1 : 0)
            .animation(.easeOut(duration: 0.5), value: showing)
        } else {
          AppScreen()
            .environmentObject(APIManager.shared)
        }
      }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          showing.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
          withAnimation {
            starLaunch.toggle()
          }
        }
      }
    }
  }
}

// MARK: - Typealias

typealias EmptyClosure = () -> Swift.Void

typealias NormalClosure<T> = (T) -> Swift.Void

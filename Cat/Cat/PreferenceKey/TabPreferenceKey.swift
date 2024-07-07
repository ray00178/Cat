//
//  TabPreferenceKey.swift
//  Cat
//
//  Created by Ray on 2024/7/7.
//

import SwiftUI

// MARK: - TabPreferenceKey

struct TabPreferenceKey: PreferenceKey {
  static var defaultValue: [Tab] = []

  static func reduce(value: inout [Tab], nextValue: () -> [Tab]) {
    value += nextValue()
  }
}

// MARK: - TabViewModifer

struct TabViewModifer: ViewModifier {
  let tab: Tab
  @Binding var selected: Tab

  func body(content: Content) -> some View {
    content
      .preference(key: TabPreferenceKey.self, value: [tab])
  }
}

// MARK: - TabBarItemViewModiferWithOnAppear

struct TabModiferWithOnAppear: ViewModifier {
  let tab: Tab
  @Binding var selected: Tab

  @ViewBuilder func body(content: Content) -> some View {
    if selected == tab {
      content
        .opacity(1)
        .preference(key: TabPreferenceKey.self, value: [tab])
    } else {
      Text("")
        .opacity(0)
        .preference(key: TabPreferenceKey.self, value: [tab])
    }
  }
}

extension View {
  func tabBarItem(tab: Tab, selected: Binding<Tab>) -> some View {
    modifier(TabModiferWithOnAppear(tab: tab, selected: selected))
  }
}

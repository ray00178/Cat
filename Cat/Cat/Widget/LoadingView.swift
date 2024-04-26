//
//  LoadingView.swift
//  Cat
//
//  Created by Ray on 2024/4/21.
//

import SwiftUI

struct LoadingView: View {
  
  @State private var loading: Bool = false
  
  private var width: CGFloat
  
  init(width: CGFloat = 16.0) {
    self.width = width
  }
  
  var body: some View {
    HStack(spacing: 8) {
      circle(color: .red, delay: 0.0)
      circle(color: .yellow, delay: 0.2)
      circle(color: .blue, delay: 0.4)
    }
    .onAppear {
      loading = true
    }
    .onDisappear {
      loading = false
    }
  }
  
  @ViewBuilder
  private func circle(color: Color, delay: CGFloat) -> some View {
    Circle()
      .foregroundStyle(color)
      .frame(width: width)
      .opacity(loading ? 0.2 : 1)
      .scaleEffect(loading ? 1.6 : 1)
      .animation(.easeInOut(duration: 0.6).repeatForever().delay(delay),
                 value: loading)
  }
}

#Preview {
  LoadingView()
}

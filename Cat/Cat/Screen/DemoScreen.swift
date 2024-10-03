//
//  DemoScreen.swift
//  Cat
//
//  Created by Ray on 2024/8/17.
//

import SwiftUI

// MARK: - DemoScreen

// Reference = https://fatbobman.com/zh/posts/new_navigator_of_swiftui_4/

struct DemoScreen: View {
  @State private var scaleBool: Bool = false
  @State private var current: Category?
  @State private var path: [Category] = .empty
  @State private var isPresent: Bool = false
  
  private let categories: [Category] = [
    .parallaxImage, .circleAvtor, .glowText,
    .animation, .swiftchart, .sunrise,
    .appicon
  ]

  private let screenW: CGFloat = UIScreen.main.bounds.width
  private let column: CGFloat = 2
  private let padding: CGFloat = 12

  var body: some View {
    let itemValue = (screenW - ((column + 1) * padding)) / column

    NavigationStack(path: $path) {
      ScrollView {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(itemValue),
                                                     spacing: padding),
                                 count: Int(column)),
                  spacing: padding)
        {
          // id 如果沒有指定，則點擊事件會失效錯亂
          ForEach(categories, id: \.self) { category in
            DemoCard(category: category, wh: itemValue) {
              if category == .animation {
                isPresent.toggle()
              } else {
                path.append(category)
              }
            }
          }
        }
        .padding(.horizontal, padding)
      }
      .contentMargins(.bottom, 12)
      .navigationTitle("Demo")
      .navigationBarTitleDisplayMode(.large)
      .navigationDestination(for: Category.self) { categoty in
        switch categoty {
        case .parallaxImage:
          ParallaxImageScreen(path: $path)
        case .circleAvtor:
          CircleAvtorScreen(path: $path)
        case .glowText:
          GlowTextScreen()
        case .animation:
          EmptyView()
        case .swiftchart:
          SwiftCharScreen()
        case .sunrise:
          SunAnimationScreen()
        case .appicon:
          AppIconScreen()
        }
      }
      .sheet(isPresented: $isPresent) {
        AnimationPracticeScreen()
      }
      /*.fullScreenCover(isPresented: $isPresent) {
        AnimationPracticeScreen()
      }*/
    }
  }
}

// MARK: - DemoCard

private struct DemoCard: View {
  
  private(set) var category: Category

  private(set) var wh: CGFloat

  private(set) var tap: EmptyClosure?
  
  private let duration: TimeInterval = 0.2
  
  @State private var isActive: Bool = false

  init(category: Category, wh: CGFloat, tap: EmptyClosure?) {
    self.category = category
    self.wh = wh
    self.tap = tap
  }

  var body: some View {
    Button {
      isActive.toggle()

      DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
        isActive.toggle()
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + (duration * 2)) {
        tap?()
      }
    } label: {
      Rectangle()
        .fill(.cF6F6F6)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(width: wh, height: wh)
        .overlay(alignment: .topLeading) {
          VStack(alignment: .leading) {
            Image(category.image)
              .resizable()
              .scaledToFill()
              .frame(width: 80, height: 80)
              .clipped()
              // Inner radius = Outer radius - (Padding/2)
              .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(category.date)
              .font(.title3)
              .foregroundStyle(.c888888)
              .fontWeight(.bold)
              .fontDesign(.rounded)
              .padding(.top, 8)

            Text(category.title)
              .font(.title2)
              .foregroundStyle(.c374957)
              .fontWeight(.bold)
              .fontDesign(.rounded)
              .lineLimit(1, reservesSpace: true)
          }
          .padding(12)
        }
        .animation(.smooth(duration: duration)) { content in
          content.scaleEffect(isActive ? 0.8 : 1.0)
        }
    }
  }
}

// MARK: - Category

enum Category: Identifiable, Hashable {
  case parallaxImage

  case circleAvtor

  case glowText
  
  case animation
  
  case swiftchart
  
  case sunrise
  
  case appicon

  var id: String {
    UUID().uuidString
  }

  var date: String {
    switch self {
    case .parallaxImage:
      "2024/07/24"
    case .circleAvtor:
      "2024/08/04"
    case .glowText:
      "2024/08/04"
    case .animation:
      "2024/08/25"
    case .swiftchart:
      "2024/08/31"
    case .sunrise:
      "2024/10/02"
    case .appicon:
      "2024/10/03"
    }
  }

  var title: String {
    switch self {
    case .parallaxImage:
      "Parallax Image"
    case .circleAvtor:
      "Circle Avtor"
    case .glowText:
      "Glow Text"
    case .animation:
      "Animation"
    case .swiftchart:
      "Swift Chart"
    case .sunrise:
      "Sunrise"
    case .appicon:
      "AppIcon"
    }
  }

  var image: ImageResource {
    switch self {
    case .parallaxImage, .animation, .appicon:
      .image1Min
    case .circleAvtor, .swiftchart:
      .image2Min
    case .glowText, .sunrise:
      .image3Min
    }
  }
}

#Preview {
  DemoScreen()
}

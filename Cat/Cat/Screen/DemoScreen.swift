//
//  DemoScreen.swift
//  Cat
//
//  Created by Ray on 2024/8/17.
//

import SwiftUI

// MARK: - DemoScreen
// Reference = https://fatbobman.com/zh/posts/new_navigator_of_swiftui_4/

@MainActor
struct DemoScreen: View {
  
  @State private var current: Category?
  @State private var path: [Category] = .empty
  
  private let categories: [Category] = [
    .parallaxImage, .circleAvtor, .glowText
  ]
  
  private let screenW: CGFloat = UIScreen.main.bounds.width
  private let column: CGFloat = 2
  private let padding: CGFloat = 12
  
  var body: some View {
    let itemValue = (screenW - ((column + 1) * padding)) / column
    
    NavigationStack(path: $path) {
      ScrollView {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(itemValue)),
                                 count: Int(column)),
                  spacing: padding)
        {
          ForEach(categories) { category in
            card(category: category, wh: itemValue)
              .scaleEffect(current == category ? 0.8 : 1)
              .animation(.snappy, value: current)
              .onTapGesture { _ in
                current = category
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                  current = nil
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                  path.append(category)
                }
              }
          }
        }
        .padding(.horizontal, padding)
      }
      .navigationTitle("Demo")
      .navigationBarTitleDisplayMode(.large)
      .navigationDestination(for: Category.self) { categoty in
        switch categoty {
        case .parallaxImage:
          ParallaxImageView(path: $path)
        default:
          EmptyView()
        }
      }
    }
  }
  
  @ViewBuilder
  /// Card
  /// - Parameters:
  ///   - category: Category Model
  ///   - wh: Card width, height
  /// - Returns: Card View
  private func card(category: Category, wh: CGFloat) -> some View {
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
            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
        }
        .padding(12)
      }
  }
}

enum Category: Identifiable, Hashable {
  case parallaxImage
  
  case circleAvtor
  
  case glowText
  
  var id: String {
    return UUID().uuidString
  }
  
  var date: String {
    switch self {
    case .parallaxImage:
      return "2024/07/24"
    case .circleAvtor:
      return "2024/08/04"
    case .glowText:
      return "2024/08/04"
    }
  }
  
  var title: String {
    switch self {
    case .parallaxImage:
      return "Parallax Image"
    case .circleAvtor:
      return "Circle Avtor"
    case .glowText:
      return "Glow Text"
    }
  }
  
  var image: ImageResource {
    switch self {
    case .parallaxImage:
      return .image1Min
    case .circleAvtor:
      return .image2Min
    case .glowText:
      return .image3Min
    }
  }
}

#Preview {
  DemoScreen()
}

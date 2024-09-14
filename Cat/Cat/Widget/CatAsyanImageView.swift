//
//  CatAsyanImageView.swift
//  Profile
//
//  Created by Ray on 2024/3/23.
//

import SwiftUI
import UIKit

// MARK: - CatAsyanImageView

// Reference: https://matteomanferdini.com/swiftui-asyncimage/
struct CatAsyanImageView: View {
  
  @State private var start: Bool = false
  @State private var image: Image?

  /// Resource
  var url: URL?
  
  /// Save Photo
  var savePhoto: DataClosure<Image>?
  
  var body: some View {
    AsyncImage(url: url, transaction: .init(animation: .bouncy)) { phase in
      switch phase {
      case .empty, .failure:
        Image(.placeholderCat)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .opacity(0)
          .overlay {
            ProgressView()
          }
      case let .success(image):
        image
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .transition(.opacity)
          .onAppear {
            self.image = image
          }
      @unknown default:
        EmptyView()
      }
    }
    .contextMenu {
      if let image {
        ShareLink(item: image, preview: SharePreview("Image", image: image)) {
          Label("Share via", systemImage: "square.and.arrow.up")
        }

        Button {
          savePhoto?(image)
        } label: {
          Label("Save Photo", systemImage: "square.and.arrow.down")
        }
      }

      if let url {
        ShareLink(item: url) {
          Label("Link", systemImage: "link")
        }
      }
    }
  }
}

#Preview {
  CatAsyanImageView(
    url: URL(string: "https://cdn2.thecatapi.com/images/d9b.jpg"))
}

// MARK: - LayoutType

enum LayoutType {
  case left

  case right

  case center
}

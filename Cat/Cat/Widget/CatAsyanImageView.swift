//
//  CatAsyanImageView.swift
//  Profile
//
//  Created by Ray on 2024/3/23.
//

import SwiftUI

// MARK: - CatAsyanImageView

struct CatAsyanImageView: View {
  
  /// Resource
  var url: URL?

  var padding: CGFloat = .zero

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
      @unknown default:
        EmptyView()
      }
    }
    .contextMenu {
      if let url,
         let data = try? Data(contentsOf: url),
         let uiImage = UIImage(data: data)
      {
        let image = Image(uiImage: uiImage)
        ShareLink(item: image, preview: SharePreview("Image", image: image)) {
          Label("Share", systemImage: "square.and.arrow.up")
        }

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

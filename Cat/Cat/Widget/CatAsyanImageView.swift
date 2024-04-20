//
//  CatAsyanImageView.swift
//  Profile
//
//  Created by Ray on 2024/3/23.
//

import SwiftUI

// MARK: - CatAsyanImageView

struct CatAsyanImageView: View {
  @EnvironmentObject private var apiManager: APIManager
  
  @State private var image: Image?
  
  /// Resource
  var url: URL?

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
      if let image {
        ShareLink(item: image, preview: SharePreview("Image", image: image)) {
          Label("Share via", systemImage: "square.and.arrow.up")
        }
      }

      if let url {
        ShareLink(item: url) {
          Label("Link", systemImage: "link")
        }
      }
    }
    .onAppear {
      Task {
        if let url = url?.absoluteString,
           let data = await apiManager.fetchData(from: url),
           data.count != 0,
           let uiImage = UIImage(data: data)
        {
          image = Image(uiImage: uiImage)
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

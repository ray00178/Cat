//
//  CatLeftView.swift
//  Profile
//
//  Created by Ray on 2024/2/13.
//

import SwiftUI

/// 左邊樣式 View
/// ```
/// Layout
/// ■■■■ ■
/// ■■■■ ■
/// ■■■■■■
/// ```
struct CatLeftView: View {
  var cats: [CatImage] = .empty

  var onPress: DataClosure<CatImage>?

  var savePhoto: DataClosure<Image>?

  var body: some View {
    let cat = cats.first
    let urls = cats.dropFirst()

    Grid(horizontalSpacing: 1) {
      GridRow {
        CatAsyanImageView(url: cat?.url, savePhoto: savePhoto)
        .gridCellColumns(2)
        .onTapGesture {
          if let cat {
            onPress?(cat)
          }
        }

        Grid(verticalSpacing: 1) {
          ForEach(urls) { cat in
            CatAsyanImageView(url: cat.url, savePhoto: savePhoto)
            .onTapGesture {
              onPress?(cat)
            }
          }
        }
      }
    }
  }
}

#Preview {
  CatLeftView(cats: CatImage.mockData())
    .environmentObject(APIManager.shared)
}

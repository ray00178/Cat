//
//  CatRightView.swift
//  Profile
//
//  Created by Ray on 2024/2/18.
//

import SwiftUI

struct CatRightView: View {
  var cats: [CatImage] = .empty

  var onPress: ((CatImage) -> Swift.Void)?

  var body: some View {
    let cat = cats.last
    let urls = cats.dropLast()

    Grid(horizontalSpacing: 1) {
      GridRow {
        Grid(verticalSpacing: 1) {
          ForEach(urls) { cat in
            CatAsyanImageView(url: cat.url)
              .onTapGesture {
                onPress?(cat)
              }
          }
        }

        CatAsyanImageView(url: cat?.url)
          .gridCellColumns(2)
          .onTapGesture {
            if let cat {
              onPress?(cat)
            }
          }
      }
    }
  }
}

#Preview {
  CatRightView(cats: CatImage.mockData())
}

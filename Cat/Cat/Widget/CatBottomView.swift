//
//  CatBottomView.swift
//  Profile
//
//  Created by Ray on 2024/2/18.
//

import SwiftUI

struct CatBottomView: View {
  var cats: [CatImage] = .empty

  var onPress: ((CatImage) -> Swift.Void)?

  var didPhotoSaveSuccess: DataClosure<Image>?

  var body: some View {
    Grid(horizontalSpacing: 1) {
      GridRow {
        ForEach(cats) { cat in
          CatAsyanImageView(url: cat.url, didPhotoSaveSuccess: { image in
            didPhotoSaveSuccess?(image)
          })
          .onTapGesture {
            onPress?(cat)
          }
        }
      }
    }
  }
}

#Preview {
  CatBottomView(cats: CatImage.mockData())
}

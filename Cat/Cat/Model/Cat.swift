//
//  Cat.swift
//  Profile
//
//  Created by Ray on 2024/3/23.
//

import Foundation
import SwiftUI

// MARK: - Cat

struct Cat: Identifiable, Hashable {
  
  private(set) var id: String = UUID().uuidString

  private(set) var layout: Layout

  private(set) var images: [CatImage]

  init() {
    layout = .average
    images = .empty
  }

  init(layout: Layout, images: [CatImage]) {
    self.layout = layout
    self.images = images
  }
}

extension Cat {
  
  /// From Array of CatImage to Array Cat
  /// - Parameter catImages: [CatImage]
  /// - Returns: [Cat]]
  static func convertWith(catImages: [CatImage]) -> [Cat] {
    
    let chunks = catImages.chunks(of: 3)

    var values: [Cat] = .empty

    for (index, images) in chunks.enumerated() {
      if index.isMultiple(of: 4) {
        values.append(Cat(layout: .left, images: images))
      }
      else if index % 2 == 1 {
        values.append(Cat(layout: .average, images: images))
      }
      else if index.isMultiple(of: 2) {
        values.append(Cat(layout: .right, images: images))
      }
    }
    
    return values
  }
}

// MARK: Cat.Layout

extension Cat {
  
  /// View Layout Type
  enum Layout {
    
    case left

    case right

    case average
  }
}

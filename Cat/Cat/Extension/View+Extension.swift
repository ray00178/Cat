//
//  View+Extension.swift
//  Cat
//
//  Created by Ray on 2024/5/1.
//

import UIKit
import SwiftUI

extension View {
  
  /// Any View convert to UIImage
  /// Reference: https://pse.is/5vuxhm
  func snapshot() -> UIImage {
    let controller = UIHostingController(rootView: self)
    let view = controller.view

    let targetSize = controller.view.intrinsicContentSize
    view?.bounds = CGRect(origin: .zero, size: targetSize)
    view?.backgroundColor = .clear

    let renderer = UIGraphicsImageRenderer(size: targetSize)
    
    return renderer.image { _ in
      view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
    }
  }
}

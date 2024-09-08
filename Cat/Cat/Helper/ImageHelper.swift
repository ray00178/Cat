//
//  ImageHelper.swift
//  Cat
//
//  Created by Ray on 2024/5/1.
//

import SwiftUI
import UIKit

class ImageHelper: NSObject {
  @MainActor static let shared: ImageHelper = .init()

  enum Status: Error {
    case success
    case failure(message: String)
  }

  override private init() {}

  var didCompleted: DataClosure<Status>?

  @MainActor
  public func savePhoto(image: Image?) {
    guard let uiImage = ImageRenderer(content: image).uiImage
    else {
      print("Save Failure UIImage is Nil")
      return
    }

    UIImageWriteToSavedPhotosAlbum(
      uiImage,
      self,
      #selector(completed(_:didFinishSavingWithError:contextInfo:)),
      nil
    )
  }

  @objc
  private func completed(_: UIImage, didFinishSavingWithError error: Error?, contextInfo _: UnsafeRawPointer) {
    guard let error else {
      didCompleted?(.success)
      return
    }
    
    didCompleted?(.failure(message: error.localizedDescription))
  }
}

//
//  ImageHelper.swift
//  Cat
//
//  Created by Ray on 2024/5/1.
//

import UIKit
import SwiftUI

class ImageHelper: NSObject {
  
  static let shared: ImageHelper = .init()
  
  private override init() {}
  
  var didCompleted: EmptyClosure?
  
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
      didCompleted?()
      return
    }
    
    print("Save failure \(error.localizedDescription)!")
  }
}

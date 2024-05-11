//
//  ImageHelper.swift
//  Cat
//
//  Created by Ray on 2024/5/1.
//

import UIKit

class ImageHelper: NSObject {
  
  var didCompleted: EmptyClosure?
  
  public func savePhoto(uiImage: UIImage) {
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

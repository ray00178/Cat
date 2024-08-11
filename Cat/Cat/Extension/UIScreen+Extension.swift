//
//  UIScreen+Extension.swift
//  Cat
//
//  Created by Ray on 2024/8/10.
//

import UIKit

extension UIScreen {
  /// Return the width of a rectangle.
  static var width: CGFloat {
    UIScreen.main.bounds.width
  }

  /// Return the height of a rectangle.
  static var height: CGFloat {
    UIScreen.main.bounds.height
  }

  /// Return the statusBar height of a rectangle.
  static var statusBarHeight: CGFloat {
    return UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
  }

  /// The natural scale factor associated with the screen.
  static var density: CGFloat {
    UIScreen.main.scale
  }

  /// Return the orientation of now.
  static var orientation: UIDeviceOrientation {
    UIDevice.current.orientation
  }

  /// Return the device is landscape.
  static var isLandscape: Bool {
    UIDevice.current.orientation.isLandscape
  }

  /// Return the device is portrait.
  static var isPortrait: Bool {
    UIDevice.current.orientation.isPortrait
  }
}

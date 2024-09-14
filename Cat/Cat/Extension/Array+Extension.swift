//
//  Array+Extension.swift
//  Profile
//
//  Created by Ray on 2024/4/3.
//

import Foundation

extension Array {
  
  static var empty: Self { [] }
  
  var isNotEmpty: Bool { self.isEmpty == false }
  
  var data: Data? {
    return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
  }
}

extension Array {
  
  func chunks(of size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
  }
  
}

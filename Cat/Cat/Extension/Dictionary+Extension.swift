//
//  Dictionary+Extension.swift
//  Profile
//
//  Created by Ray on 2024/4/3.
//

import Foundation

extension Dictionary {
  
  var data: Data? {
    try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
  }
  
  var string: String? {
    guard let data = self.data,
          let result = String(data: data, encoding: .utf8)
    else {
      return nil
    }
    
    return result
  }
}

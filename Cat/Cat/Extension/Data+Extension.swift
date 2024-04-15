//
//  Data+Extension.swift
//  Profile
//
//  Created by Ray on 2024/4/3.
//

import Foundation

extension Data {
  
  var string: String? { String(data: self, encoding: .utf8) }
  
  var dictionary: Dictionary<String, Any>? {
    guard let obj = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
          let dic = obj as? Dictionary<String, Any>
    else {
      return nil
    }
    
    return dic
  }
}

//
//  APIRequest.swift
//  Profile
//
//  Created by Ray on 2024/4/3.
//

import Foundation

struct APIRequest: Hashable {
  
  /// Http method, default = .post
  private(set) var method: HTTPMethod
  
  private(set) var path: String
  
  private(set) var parameters: [String: String]?
  
  private(set) var header: [String: String] = [:]
  
  init(method: HTTPMethod = .post, path: String, parameters: [String: String]? = nil) {
    header["Content-Type"] = "application/json"
    header["x-api-key"] = APISecret.key
    
    self.method = method
    self.path = path
    
    switch method {
    case .get:
      var components = URLComponents(string: path)
      components?.queryItems = parameters?.map({ URLQueryItem(name: $0.key, value: $0.value) })
      
      if let url = components?.url?.absoluteString {
        self.path = url
        self.parameters = nil
      }
    case .post:
      if let p = parameters {
        self.parameters = p
      }
    }
  }
  
  mutating func addHeaders(value: [String: String]) {
    value.forEach { header[$0.key] = $0.value }
  }
}

// MARK: Enum

extension APIRequest {
  
  enum HTTPMethod: String {
    
    case get = "GET"
    
    case post = "POST"
  }
}

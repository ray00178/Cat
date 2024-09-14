//
//  URLSession+Extension.swift
//  Profile
//
//  Created by Ray on 2024/4/4.
//

import Foundation

extension URLSession {
  
  /// Use for normal request
  static let normalSession: URLSession = {
    // Reference: https://www.avanderlee.com/swift/urlsessionconfiguration/
    let config: URLSessionConfiguration = URLSessionConfiguration.default
    config.waitsForConnectivity = true
    config.timeoutIntervalForRequest = 30
    config.timeoutIntervalForResource = 30
    config.multipathServiceType = .handover
    config.httpAdditionalHeaders = ["Content-Type": "application/json"]
    
    return URLSession(configuration: config)
  }()
  
  /// Use for image download
  static let cacheSession: URLSession = {
    let config: URLSessionConfiguration = URLSessionConfiguration.default
    
    // memory = 20MB
    // disk = 50MB
    config.urlCache = URLCache(memoryCapacity: 30 * 1024 * 1024,
                               diskCapacity: 50 * 1024 * 1024,
                               directory: FileManager.default.temporaryDirectory)
    
    return URLSession(configuration: config)
  }()
  
}

//
//  APIManager.swift
//  Profile
//
//  Created by Ray on 2024/2/25.
//

import Foundation
import SwiftUI

// Reference: https://pse.is/5wcbfw
final class APIManager: ObservableObject, Sendable {
  
  static let shared: APIManager = .init()
  
  private init() {}
}

// MARK: - Http Request

extension APIManager {
  
  // Reference: https://www.avanderlee.com/concurrency/concurrency-safe-global-variables-to-prevent-data-races/
  
  /// Http Request
  /// - Parameters:
  ///   - request: APIRequest Model
  ///   - type: Model Type
  ///   - session: URLSession, default = .normalSession
  /// - Returns: Model Type
  private func request<T: Decodable>(request: APIRequest,
                                     type: T.Type,
                                     using session: URLSession = .normalSession) async throws -> T {
    guard let urlEncoding = request.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: urlEncoding)
    else {
      throw APIError(kind: .invalidateURL)
    }
    
    var req = URLRequest(url: url)
    req.httpMethod = request.method.rawValue
    req.httpBody = request.parameters?.data
    
    request.header.forEach({ req.addValue($0.value, forHTTPHeaderField: $0.key) })
    
    let (data, response) = try await session.data(for: req, delegate: nil)
    
    // Reference: https://a11y-guidelines.orange.com/en/mobile/ios/wwdc/nota11y/2021/2110095/
    guard let httpResponse = response as? HTTPURLResponse 
    else {
      throw APIError(kind: .httpUnknownError)
    }
          
    guard 200...299 ~= httpResponse.statusCode
    else {
      throw APIError(statusCode: httpResponse.statusCode, kind: .responseFailure)
    }
    
    return try JSONDecoder().decode(T.self, from: data)
  }
  
  /// Http Request Data
  /// - Parameters:
  ///   - request: APIRequest Model
  ///   - session: URLSession, default = .normalSession
  /// - Returns: Data, Maybe return nil
  private func request(request: APIRequest,
                       using session: URLSession = .normalSession) async throws -> Data {
    guard let urlEncoding = request.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: urlEncoding)
    else {
      throw APIError(kind: .invalidateURL)
    }
    
    var req = URLRequest(url: url)
    req.httpMethod = request.method.rawValue
    
    request.header.forEach({ req.addValue($0.value, forHTTPHeaderField: $0.key) })
    
    let (data, response) = try await session.data(for: req, delegate: nil)
    
    // Reference: https://a11y-guidelines.orange.com/en/mobile/ios/wwdc/nota11y/2021/2110095/
    guard let httpResponse = response as? HTTPURLResponse
    else {
      throw APIError(kind: .httpUnknownError)
    }
          
    guard 200...299 ~= httpResponse.statusCode
    else {
      throw APIError(statusCode: httpResponse.statusCode, kind: .responseFailure)
    }
    
    return data
  }
}

// MARK: - Cat API

extension APIManager {
  
  public func fetchCatImages(page: Int, limit: Int = 24) async -> [CatImage] {
    let parameters: [String: String] = [
      "page": "\(page)",
      "limit": "\(24)",
      "order": "DESC",
      "has_breeds": "1",
    ]
    
    let req = APIRequest(method: .get, path: APISecret.domain, parameters: parameters)
    
    let requestInfo: String = """
    🔥🔥🔥 Request Post 🔥🔥🔥
    \(req.method.rawValue) [\(req.path)]
    \(req.header)
    \(String(describing: req.parameters?.string))
    """
    print(requestInfo)
    
    do {
      let result = try await request(request: req, type: [CatImage].self, using: .cacheSession)
      return result
    } catch let error as APIError {
      let message: String = """
      ‼️‼️‼️APIError‼️‼️‼️
      \(error.kind)
      \(String(describing: error.statusCode))
      """
      print(message)
      return .empty
    } catch {
      let message: String = """
      ‼️‼️‼️Error‼️‼️‼️
      \(error.localizedDescription)
      """
      print(message)
      return .empty
    }
  }
  
  public func fetchData(from url: String) async -> Data? {
    let req = APIRequest(method: .get, path: url)
    
    let requestInfo: String = """
    🔥🔥🔥 Request Get 🔥🔥🔥
    \(req.method.rawValue) [\(req.path)]
    \(req.header)
    """
    print(requestInfo)
    
    do {
      let result = try await request(request: req, using: .cacheSession)
      return result
    } catch let error as APIError {
      let message: String = """
      ‼️‼️‼️APIError‼️‼️‼️
      \(error.kind)
      \(String(describing: error.statusCode))
      """
      print(message)
      return nil
    } catch {
      let message: String = """
      ‼️‼️‼️Error‼️‼️‼️
      \(error.localizedDescription)
      """
      print(message)
      return nil
    }
  }
}

// MARK: - API Error

struct APIError: Error {
  
  enum ErrorKind {
    
    case invalidateURL
    
    case httpUnknownError
    
    case responseFailure
  }
  
  private(set) var statusCode: Int?
  
  private(set) var kind: ErrorKind
  
  init(statusCode: Int? = nil, kind: ErrorKind) {
    self.statusCode = statusCode
    self.kind = kind
  }
}

// MARK: - Environment

struct APIManagerKey: EnvironmentKey {
    static var defaultValue: APIManager = .shared
}

extension EnvironmentValues {
  var apiManager: APIManager {
    get { self[APIManagerKey.self] }
    set { self[APIManagerKey.self] = newValue }
  }
}

//
//  APIManager.swift
//  Profile
//
//  Created by Ray on 2024/2/25.
//

import Foundation

// MARK: - APIManager

// Reference: https://pse.is/5wcbfw
struct APIManager: Sendable {
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
  public func request<T: Decodable>(request: APIRequest,
                                    type _: T.Type,
                                    using session: URLSession = .normalSession) async throws -> T
  {
    guard let urlEncoding = request.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: urlEncoding)
    else {
      throw APIError(kind: .invalidateURL)
    }

    var req = URLRequest(url: url)
    req.httpMethod = request.method.rawValue
    req.httpBody = request.parameters?.data

    request.header.forEach { req.addValue($0.value, forHTTPHeaderField: $0.key) }

    let (data, response) = try await session.data(for: req, delegate: nil)
    print("APIManager is in Main Thread = \(Thread.isMainThread)")
    // Reference: https://a11y-guidelines.orange.com/en/mobile/ios/wwdc/nota11y/2021/2110095/
    guard let httpResponse = response as? HTTPURLResponse
    else {
      throw APIError(kind: .httpUnknownError)
    }

    guard 200 ... 299 ~= httpResponse.statusCode
    else {
      throw APIError(statusCode: httpResponse.statusCode, kind: .responseFailure)
    }

    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      throw APIError(statusCode: httpResponse.statusCode, kind: .decodingError)
    }
  }

  /// Http Request Data
  /// - Parameters:
  ///   - request: APIRequest Model
  ///   - session: URLSession, default = .normalSession
  /// - Returns: Data, Maybe return nil
  public func request(request: APIRequest,
                      using session: URLSession = .normalSession) async throws -> Data
  {
    guard let urlEncoding = request.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: urlEncoding)
    else {
      throw APIError(kind: .invalidateURL)
    }

    var req = URLRequest(url: url)
    req.httpMethod = request.method.rawValue

    request.header.forEach { req.addValue($0.value, forHTTPHeaderField: $0.key) }

    let (data, response) = try await session.data(for: req, delegate: nil)

    // Reference: https://a11y-guidelines.orange.com/en/mobile/ios/wwdc/nota11y/2021/2110095/
    guard let httpResponse = response as? HTTPURLResponse
    else {
      throw APIError(kind: .httpUnknownError)
    }

    guard 200 ... 299 ~= httpResponse.statusCode
    else {
      throw APIError(statusCode: httpResponse.statusCode, kind: .responseFailure)
    }

    return data
  }
}

// MARK: - APIError

struct APIError: Error {
  enum ErrorKind {
    case invalidateURL

    case httpUnknownError

    case responseFailure

    case decodingError
  }

  private(set) var statusCode: Int?

  private(set) var kind: ErrorKind

  init(statusCode: Int? = nil, kind: ErrorKind) {
    self.statusCode = statusCode
    self.kind = kind
  }
}

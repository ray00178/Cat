//
//  CatRepository.swift
//  Cat
//
//  Created by Ray on 2024/9/14.
//

import Foundation
import Observation

// Reference = https://fatbobman.com/zh/posts/swiftui-views-and-mainactor/
@Observable
@MainActor
class CatRepository {
  
  let apiManager: APIManager
  
  private(set) var cats2: [CatImage] = .empty
  
  init(apiManager: APIManager) {
    self.apiManager = apiManager
  }
}

// MARK: - API

extension CatRepository {
  
  public func fetchCatImages(page: Int, limit: Int = 51, refresh: Bool = false) async {
    if refresh {
      cats2.removeAll()
    }
    
    let parameters: [String: String] = [
      "page": "\(page)",
      "limit": "\(limit)",
      "order": "DESC",
      "has_breeds": "1",
    ]

    let req = APIRequest(method: .get, path: APISecret.domain, parameters: parameters)

    let requestInfo = """
    🔥🔥🔥 Request Post 🔥🔥🔥
    \(req.method.rawValue) [\(req.path)]
    \(req.header)
    \(String(describing: req.parameters?.string))
    """
    print(requestInfo)

    do {
      let result = try await apiManager.request(request: req, type: [CatImage].self, using: .cacheSession)
      cats2.append(contentsOf: result)
      print("Repo is in Main Thread = \(Thread.isMainThread)")
    } catch let error as APIError {
      let message = """
      ‼️‼️‼️APIError‼️‼️‼️
      \(error.kind)
      \(String(describing: error.statusCode))
      """
      print(message)
    } catch {
      let message = """
      ‼️‼️‼️Error‼️‼️‼️
      \(error.localizedDescription)
      """
      print(message)
    }
  }
  
  public func fetchData(from url: String) async -> Data? {
    let req = APIRequest(method: .get, path: url)

    let requestInfo = """
    🔥🔥🔥 Request Get 🔥🔥🔥
    \(req.method.rawValue) [\(req.path)]
    \(req.header)
    """
    print(requestInfo)

    do {
      let result = try await apiManager.request(request: req, using: .cacheSession)
      return result
    } catch let error as APIError {
      let message = """
      ‼️‼️‼️APIError‼️‼️‼️
      \(error.kind)
      \(String(describing: error.statusCode))
      """
      print(message)
      return nil
    } catch {
      let message = """
      ‼️‼️‼️Error‼️‼️‼️
      \(error.localizedDescription)
      """
      print(message)
      return nil
    }
  }
}

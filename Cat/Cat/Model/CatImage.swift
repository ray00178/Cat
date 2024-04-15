//
//  CatImage.swift
//  Profile
//
//  Created by Ray on 2024/4/4.
//

import Foundation

struct CatImage: Identifiable, Hashable, Decodable {
  
  private(set) var id: String = UUID().uuidString
  
  private(set) var imageId: String?
  
  private(set) var url: URL?
  
  private(set) var width: Int = 0
  
  private(set) var height: Int = 0
  
  private enum CodingKeys: String, CodingKey {
    case imageId = "id"
    case url = "url"
    case width = "width"
    case height = "height"
  }
  
  init() {}
  
  init(url: URL?) {
    self.url = url
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    imageId = try container.decodeIfPresent(String.self, forKey: .imageId)
    url = try container.decodeIfPresent(URL.self, forKey: .url)
    if let value = try? container.decodeIfPresent(Int.self, forKey: .width) {
      width = value
    }
    
    if let value = try? container.decodeIfPresent(Int.self, forKey: .height) {
      height = value
    }
  }
}

// MARK: Mock Data

extension CatImage {
  static func mockData() -> [CatImage] {
    ["https://cdn2.thecatapi.com/images/d9b.jpg",
     "https://cdn2.thecatapi.com/images/c3s.jpg",
     "https://cdn2.thecatapi.com/images/b73.jpg"].map { value in
      CatImage(url: URL(string: value))
    }
  }
}

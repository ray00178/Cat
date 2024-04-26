//
//  CatDetailScreen.swift
//  Cat
//
//  Created by Ray on 2024/4/13.
//

import SwiftUI

struct CatDetailScreen: View {
  
  @Environment(\.dismiss) var dismiss
  
  @Binding var path: NavigationPath
  
  var catImage: CatImage
  
  var body: some View {
    Text(catImage.imageId ?? "imageId")
      .font(.largeTitle)
      .fontDesign(.monospaced)
      .foregroundStyle(.pink)
      .toolbar(.hidden, for: .tabBar)
      .navigationTitle(catImage.id)
      .navigationBarTitleDisplayMode(.inline)
      //.navigationBarBackButtonHidden()
      .navigationDestination(for: String.self) { value in
        Text(value)
          .font(.headline)
          .background {
            LinearGradient(colors: [.red, .purple, .yellow],
                           startPoint: .leading,
                           endPoint: .trailing)
          }
          .toolbar {
            // Use .principal
            // In iOS, iPadOS, and tvOS, the system places the principal item in the center of the navigation bar. This item takes precedent over a title specified through View/navigationTitle.
            ToolbarItem(placement: .principal) {
              Text("Cat Detail")
                .foregroundStyle(.white)
                .font(.system(size: 12, weight: .bold))
                .padding(10)
                .background(
                  RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.c050505)
                )
                .shadow(radius: 5)
            }
          }
      }
      .onTapGesture {
        path.append("Hello Already")
      }
  }
}

#Preview {
  CatDetailScreen(path: .constant(.init()), catImage: CatImage.mockData()[0])
}

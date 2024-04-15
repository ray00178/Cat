//
//  CatListView.swift
//  Profile
//
//  Created by Ray on 2024/2/18.
//

import SwiftUI

// MARK: - CatScreen

struct CatScreen: View {
  // Reference = https://pse.is/5swnzn
  @EnvironmentObject private var apiManager: APIManager

  @State private var page: Int = 0
  @State private var cats: [Cat] = .empty
  @State private var activcImageId: String?
  @State private var lastImageId: String?
  @State private var isLoading: Bool = true
  
  @State private var path: NavigationPath = .init()
  
  var body: some View {
    FullSwipeNavigationStack(path: $path) {
      ScrollView(.vertical) {
        LazyVStack(spacing: 1) {
          ForEach(cats) { cat in
            switch cat.layout {
            case .left:
              CatLeftView(cats: cat.images) { image in
                path.append(image)
              }
            case .average:
              CatBottomView(cats: cat.images) { image in
                path.append(image)
              }
            case .right:
              CatRightView(cats: cat.images) { image in
                path.append(image)
              }
            }
          }
        }
        .overlay(alignment: .bottom) {
          ProgressView()
            .offset(y: 30)
            .border(Color.black, width: 2)
          //          if isLoading {
          //            ProgressView()
          //              .offset(y: 30)
          //          }
        }
        //.padding(.bottom, 40)
        .border(Color.red)
        .scrollTargetLayout()
      }
      .scrollPosition(id: $activcImageId, anchor: .bottomTrailing)
      .onChange(of: activcImageId, { oldValue, newValue in
        if newValue == lastImageId, isLoading == false {
          //          Task {
          //            page += 1
          //            await fetch(page: page)
          //          }
        }
      })
      .refreshable {
        page = 0
        cats.removeAll()
        await fetch(page: page)
      }
      .navigationTitle("Cat Every Day")
      .navigationDestination(for: CatImage.self) { animal in
        CatDetailScreen(path: $path, catImage: animal)
          .enableFullSwipePop(true)
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: {
            
          }, label: {
            Image(systemName: "cat.fill")
          })
        }
      }
    }
    .task {
      if cats.isNotEmpty { return }
      
      await fetch(page: page)
    }
    
    /*NavigationStack(path: $path) {
      ScrollView(.vertical) {
        LazyVStack(spacing: 1) {
          ForEach(cats) { cat in
            switch cat.layout {
            case .left:
              CatLeftView(cats: cat.images) { image in
                path.append(image)
              }
            case .average:
              CatBottomView(cats: cat.images)
            case .right:
              CatRightView(cats: cat.images)
            }
          }
        }
        .overlay(alignment: .bottom) {
          ProgressView()
            .offset(y: 30)
            .border(Color.black, width: 2)
          //          if isLoading {
          //            ProgressView()
          //              .offset(y: 30)
          //          }
        }
        //.padding(.bottom, 40)
        .border(Color.red)
        .scrollTargetLayout()
      }
      .scrollPosition(id: $activcImageId, anchor: .bottomTrailing)
      .onChange(of: activcImageId, { oldValue, newValue in
        if newValue == lastImageId, isLoading == false {
          //          Task {
          //            page += 1
          //            await fetch(page: page)
          //          }
        }
      })
      .refreshable {
        page = 0
        cats.removeAll()
        await fetch(page: page)
      }
      .navigationTitle("Cat Every Day")
      .navigationDestination(for: CatImage.self) { animal in
        CatDetailScreen(catImage: animal)
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: {
            
          }, label: {
            Image(systemName: "cat.fill")
          })
        }
      }
    }
    .task {
      if cats.isNotEmpty { return }
      
      await fetch(page: page)
    }*/
  }
  
  private func fetch(page: Int) async {
    isLoading = true
    
    let images = await apiManager.fetchCatImages(page: page)
    cats.append(contentsOf: Cat.convertWith(catImages: images))
    lastImageId = cats.last?.id
    
    isLoading = false
  }
}

#Preview {
  CatScreen()
    .environmentObject(APIManager.shared)
}
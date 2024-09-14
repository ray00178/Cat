//
//  CatListView.swift
//  Profile
//
//  Created by Ray on 2024/2/18.
//

import SwiftUI

// MARK: - CatScreen

struct CatScreen: View {
  // Reference: https://pse.is/5swnzn
  
  @Environment(CatRepository.self) private var repository
  
  @State private var page: Int = 0
  @State private var cats: [Cat] = .empty
  
  @State private var activcImageId: String?
  @State private var lastImageId: String?
  
  @State private var isLoading: Bool = true
  @State private var path: NavigationPath = .init()

  @State private var alertStatus: ImageHelper.Status?
  @State private var animation: Bool = false

  // Reference = https://peterfriese.dev/blog/2024/hero-animation/
  @Namespace private var namespace

  let items: [GridItem] = [
    GridItem(.adaptive(minimum: 100, maximum: 200), spacing: 1),
    GridItem(.adaptive(minimum: 100, maximum: 200), spacing: 1),
    GridItem(.adaptive(minimum: 100, maximum: 200), spacing: 1)
  ]

  var body: some View {
    NavigationStack(path: $path) {
      if repository.cats2.isEmpty {
        Text("🥺 Try again later")
          .bold()
          .fontDesign(.rounded)
          .font(.largeTitle)
      } else {
        ScrollView(.vertical) {
          /* LazyVStack(spacing: 1) {
             ForEach(cats) { cat in
               switch cat.layout {
               case .left:
                 CatLeftView(cats: cat.images, onPress: { catImage in
                   path.append(catImage)
                 },
                 savePhoto: { image in
                   savePhotoToLibrary(image: image)
                 })
               case .average:
                 CatBottomView(cats: cat.images, onPress: { catImage in
                   path.append(catImage)
                 },
                 savePhoto: { image in
                   savePhotoToLibrary(image: image)
                 })
               case .right:
                 CatRightView(cats: cat.images, onPress: { catImage in
                   path.append(catImage)
                 },
                 savePhoto: { image in
                   savePhotoToLibrary(image: image)
                 })
               }
             }
           } */
          LazyVGrid(columns: items, spacing: 1) {
            ForEach(repository.cats2, id: \.id) { cat in
              if #available(iOS 18.0, *) {
                CatAsyanImageView(url: cat.url) { image in
                  savePhotoToLibrary(image: image)
                }
                .matchedTransitionSource(id: cat, in: namespace)
                .onTapGesture {
                  path.append(cat)
                }
                
              } else {
                CatAsyanImageView(url: cat.url) { image in
                  savePhotoToLibrary(image: image)
                }
                .onTapGesture {
                  path.append(cat)
                }
              }
            }
          }
          .scrollTargetLayout()
          .overlay(alignment: .bottom) {
            if isLoading {
              LoadingView()
                .offset(y: 40)
            }
          }
          .padding(.bottom, 40)
        }
        .scrollPosition(id: $activcImageId, anchor: .bottomTrailing)
        .onChange(of: activcImageId) { oldValue, newValue in
          if newValue == lastImageId, isLoading == false {
            Task {
              page += 1
              await fetch2(page: page)
            }
          }
        }
        .refreshable {
          page = 0
          
          await fetch2(page: page)
        }
        .navigationTitle("Cat Every Day")
        .navigationDestination(for: CatImage.self) { animal in
          if #available(iOS 18.0, *) {
            CatDetailScreen(path: $path, catImage: animal)
              .navigationTransition(.zoom(sourceID: animal, in: namespace))
          } else {
            CatDetailScreen(path: $path, catImage: animal)
          }
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
    }
    .task {
      if repository.cats2.isNotEmpty { return }

      await fetch2(page: page)
    }
    .overlay(alignment: .center) {
      switch alertStatus {
      case .success:
        successAlert()
      case let .failure(message):
        EmptyView()
      case nil:
        EmptyView()
      }
    }
  }

  @ViewBuilder
  private func successAlert() -> some View {
    ZStack {
      Rectangle()
        .fill(.white)
        .frame(width: 150, height: 150)
        .overlay {
          VStack(spacing: 12) {
            Image(systemName: "checkmark.shield")
              .font(.largeTitle)
            Text("Saved")
              .font(.headline)
          }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .opacity(animation ? 0 : 1)
        .scaleEffect(animation ? 0 : 1)
        .animation(.easeInOut(duration: 0.25), value: animation)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      Color.black.opacity(0.35)
    }
    .ignoresSafeArea()
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
        animation.toggle()
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        alertStatus = nil
      }
    }
    .onDisappear {
      animation = false
    }
  }

  /*private func fetch(page: Int) async {
    isLoading = true

    let images = await apiManager.fetchCatImages(page: page)
    cats.append(contentsOf: Cat.convertWith(catImages: images))
    lastImageId = cats.last?.id

    isLoading = false
  }*/

  private func fetch2(page: Int, refresh: Bool = false) async {
    isLoading = true

    await repository.fetchCatImages(page: page, refresh: refresh)
    lastImageId = repository.cats2.last?.id

    isLoading = false
  }

  private func savePhotoToLibrary(image: Image) {
    ImageHelper.shared.didCompleted = { status in
      alertStatus = status
    }

    ImageHelper.shared.savePhoto(image: image)
  }
}

#Preview {
  CatScreen()
    .environment(CatRepository(apiManager: APIManager.shared))
}

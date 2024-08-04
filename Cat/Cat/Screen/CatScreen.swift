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
  @EnvironmentObject private var apiManager: APIManager

  @State private var page: Int = 0
  @State private var cats: [Cat] = .empty
  @State private var activcImageId: String?
  @State private var lastImageId: String?
  @State private var isLoading: Bool = true
  @State private var path: NavigationPath = .init()

  @State private var alertStatus: ImageHelper.Status?
  @State private var animation: Bool = false

  var body: some View {
    NavigationStack(path: $path) {
      if cats.isEmpty {
        Text("🥺 Try again later")
          .bold()
          .fontDesign(.rounded)
          .font(.largeTitle)
      } else {
        ScrollView(.vertical) {
          LazyVStack(spacing: 1) {
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
          }
          .overlay(alignment: .bottom) {
            if isLoading {
              LoadingView()
                .offset(y: 24)
            }
          }
          .padding(.bottom, 40)
          .scrollTargetLayout()
        }
        .scrollPosition(id: $activcImageId, anchor: .bottomTrailing)
        .onChange(of: activcImageId) { _, newValue in
          if newValue == lastImageId, isLoading == false {
            Task {
              page += 1
              await fetch(page: page)
            }
          }
        }
        .refreshable {
          page = 0
          cats.removeAll()
          await fetch(page: page)
        }
        .navigationTitle("Cat Every Day")
        .navigationDestination(for: CatImage.self) { animal in
          CatDetailScreen(path: $path, catImage: animal)
        }
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button(action: {}, label: {
              Image(systemName: "cat.fill")
            })
          }
        }
      }
    }
    .task {
      if cats.isNotEmpty { return }

      await fetch(page: page)
    }
    .overlay(alignment: .center) {
      switch alertStatus {
      case .success:
        successAlert()
      case .failure(let message):
        EmptyView()
      case nil:
        EmptyView()
      }
    }
  }

  @MainActor
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

  private func fetch(page: Int) async {
    isLoading = true

    let images = await apiManager.fetchCatImages(page: page)
    cats.append(contentsOf: Cat.convertWith(catImages: images))
    lastImageId = cats.last?.id

    isLoading = false
  }

  private func savePhotoToLibrary(image: Image) {
    ImageHelper.shared.didCompleted = { status in
      self.alertStatus = status
    }
    
    ImageHelper.shared.savePhoto(image: image)
  }
}

#Preview {
  CatScreen()
    .environmentObject(APIManager.shared)
}

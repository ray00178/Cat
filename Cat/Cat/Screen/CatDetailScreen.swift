//
//  CatDetailScreen.swift
//  Cat
//
//  Created by Ray on 2024/4/13.
//

import SwiftUI

// MARK: - CatDetailScreen

struct CatDetailScreen: View {
  @EnvironmentObject private var apiManager: APIManager
  @Environment(\.dismiss) var dismiss

  @Binding var path: NavigationPath
  @State private var progressW: Double = 0.0
  @State private var progressH: Double = 0.0
  @State private var isImageLoaded = false
  @State private var start: Bool = false
  @State private var image: Image?
  @State private var uiImage: UIImage?

  var catImage: CatImage

  init(path: Binding<NavigationPath>, catImage: CatImage) {
    _path = path
    self.catImage = catImage
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        CatAsyanImageView(url: catImage.url)
          .clipShape(RoundedRectangle(cornerRadius: 12.0))
          .padding(.vertical, 12)
          .onTapGesture {
            if isImageLoaded {
              start.toggle()
            }
          }
          .fullScreenCover(isPresented: $start) {
            #warning("待處理 UIImage always nil")
            ZoomImageViewControllerWrapper(uiImage: UIImage(resource: .temple))
              .ignoresSafeArea()
            /* if let uiImage {
               ZoomImageViewControllerWrapper(image: uiImage)
                 .ignoresSafeArea()
             } else {
               let _ = print("uiImage = \(uiImage) ; \(image)")
             } */
          }

        Text(catImage.imageId ?? "None")
          .font(.largeTitle)
          .fontDesign(.rounded)

        HStack(spacing: 20) {
          VStack {
            Label {
              Text("Width \(catImage.width)")
                .font(.body)
                .lineLimit(1)
            } icon: {
              Image(.icRuler)
                .resizable()
                .scaledToFit()
                .frame(width: 40)
                .rotationEffect(.degrees(90))
            }

            ZStack {
              Circle()
                .stroke(.red.opacity(0.1), style: StrokeStyle(lineWidth: 16))
                .frame(width: 100)

              Circle()
                .trim(from: 0, to: progressW)
                .stroke(.red,
                        style: StrokeStyle(lineWidth: 16, lineCap: .round))
                .frame(width: 100)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeIn(duration: 1), value: progressW)
            }
          }

          Spacer()

          VStack {
            Label {
              Text("Height \(catImage.height)")
                .font(.body)
                .lineLimit(1)
            } icon: {
              Image(.icRuler)
                .resizable()
                .scaledToFit()
                .frame(width: 40)
            }

            ZStack(alignment: .center) {
              Circle()
                .stroke(.yellow.opacity(0.1), style: StrokeStyle(lineWidth: 16))
                .frame(width: 100)

              Circle()
                .trim(from: 0, to: progressH)
                .stroke(.yellow,
                        style: StrokeStyle(lineWidth: 16, lineCap: .round))
                .frame(width: 100)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeIn(duration: 1), value: progressH)
            }
          }
        }
      }
      .padding(16)
    }
    .toolbar(.hidden, for: .tabBar)
    .toolbarRole(.editor)
    .navigationTitle("Cat Detail")
    .onAppear {
      calcProgress()

      Task {
        await loadImageData()
      }
    }
  }

  private func loadImageData() async {
    if let url = catImage.url?.absoluteString,
       let data = await apiManager.fetchData(from: url),
       data.count != 0,
       let value = UIImage(data: data)
    {
      await MainActor.run {
        uiImage = value
        print("uiImage = \(uiImage)")
        image = Image(uiImage: value)
        isImageLoaded = true
      }
    }
  }
}

// MARK: - Private Function

extension CatDetailScreen {
  /// 計算進度值
  private func calcProgress() {
    let w: Int = catImage.width
    let h: Int = catImage.height

    if w > h {
      progressW = 1.0
      progressH = Double(h) / Double(w)
    }
    else if h > w {
      progressW = Double(w) / Double(h)
      progressH = 1.0
    }
    else {
      progressW = 1.0
      progressH = 1.0
    }
  }
}

#Preview {
  NavigationStack {
    CatDetailScreen(
      path: .constant(.init()),
      catImage: CatImage.mockData()[0]
    )
    .environmentObject(APIManager.shared)
  }
}

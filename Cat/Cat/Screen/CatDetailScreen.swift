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

  @State private var progressW: Double = 0.0

  @State private var progressH: Double = 0.0

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

        /* Text(catImage.imageId ?? "imageId")
         .font(.largeTitle)
         .fontDesign(.monospaced)
         .foregroundStyle(.pink)
         .frame(width: 200)
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
         } */
      }
      .padding(16)
    }
    .toolbar(.hidden, for: .tabBar)
    .toolbarRole(.editor)
    .navigationTitle("Cat Detail")
    .onAppear {
      calcProgress()
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
    CatDetailScreen(path: .constant(.init()), catImage: CatImage.mockData()[0])
      .environmentObject(APIManager.shared)
  }
}

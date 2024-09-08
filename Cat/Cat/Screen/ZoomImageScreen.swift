//
//  ZoomImageScreen.swift
//  Cat
//
//  Created by Ray on 2024/8/10.
//

import SwiftUI
import UIKit

// MARK: - ZoomImageScreen

// Reference = https://developer.apple.com/tutorials/swiftui/interfacing-with-uikit/
class ZoomImageViewController: UIViewController {
  private let scrollView: UIScrollView = .init()
  private let imageView: UIImageView = .init()

  /// Device screen frame
  private var screenFrame: CGRect = .zero

  /// Initialize ImageView center
  private var oriImageCenter: CGPoint = .zero

  private var centerOfContentSize: CGPoint {
    let deltaWidth = screenFrame.width - scrollView.contentSize.width
    let offsetX = deltaWidth > 0 ? deltaWidth / 2 : 0
    let deltaHeight = screenFrame.height - scrollView.contentSize.height
    let offsetY = deltaHeight > 0 ? deltaHeight / 2 : 0

    return CGPoint(x: scrollView.contentSize.width / 2 + offsetX,
                   y: scrollView.contentSize.height / 2 + offsetY)
  }

  /// 圖片最大縮放倍數, 計算方式 = 螢幕高度 / 圖片容器高度(imageView)
  private var imageMaxZoomScale: CGFloat = 1.0 {
    didSet { scrollView.maximumZoomScale = imageMaxZoomScale }
  }

  var image: UIImage?

  weak var delegate: ZoomImageVCDelagate?

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func viewWillTransition(to size: CGSize, with _: UIViewControllerTransitionCoordinator) {
    screenFrame = CGRect(origin: .zero, size: size)
    doLayout()
  }

  private func setup() {
    overrideUserInterfaceStyle = .light
    view.backgroundColor = .black

    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.alwaysBounceHorizontal = true
    scrollView.alwaysBounceVertical = true
    scrollView.isDirectionalLockEnabled = true
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = imageMaxZoomScale
    scrollView.contentInsetAdjustmentBehavior = .never
    scrollView.delegate = self
    view.addSubview(scrollView)
    scrollView.addSubview(imageView)

    let singleTap = UITapGestureRecognizer(target: self, action: #selector(onSingleTap(_:)))
    singleTap.numberOfTapsRequired = 1
    view.addGestureRecognizer(singleTap)

    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(_:)))
    doubleTap.numberOfTapsRequired = 2
    view.addGestureRecognizer(doubleTap)

    let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
    pan.maximumNumberOfTouches = 1
    pan.delegate = self
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(pan)

    // 雙點擊時，不觸發單擊事件
    singleTap.require(toFail: doubleTap)

    screenFrame = CGRect(origin: .zero,
                         size: CGSize(width: UIScreen.width, height: UIScreen.height))

    guard let image else { return }

    imageView.image = image

    doLayout()
  }

  private func doLayout() {
    // If has zoom, we need to scale to original
    if scrollView.zoomScale != 1.0 {
      scrollView.setZoomScale(1.0, animated: false)
    }

    // Setting scrollView frame, because when rotate the frame can't be changed
    scrollView.frame = screenFrame

    // Origin image size
    guard let imageSize = imageView.image?.size else { return }

    // Calculation screen frame
    imageView.frame = imageSize.fit(with: screenFrame)
    imageMaxZoomScale = screenFrame.height / imageView.frame.height
    oriImageCenter = imageView.center
    scrollView.setZoomScale(1.0, animated: false)
  }

  @objc private func onSingleTap(_: UITapGestureRecognizer) {}

  @objc private func onDoubleTap(_ tap: UITapGestureRecognizer) {
    if scrollView.zoomScale == 1.0 {
      let pointInView = tap.location(in: imageView)
      let w = scrollView.frame.size.width / imageMaxZoomScale
      let h = scrollView.frame.size.height / imageMaxZoomScale
      let x = pointInView.x - (w / 2.0)
      let y = pointInView.y - (h / 2.0)
      scrollView.zoom(to: CGRect(x: x, y: y, width: w, height: h), animated: true)
      scrollView.isDirectionalLockEnabled = false
    } else {
      scrollView.setZoomScale(1.0, animated: true)
      scrollView.isDirectionalLockEnabled = true
    }
  }

  @objc private func onPan(_ pan: UIPanGestureRecognizer) {
    guard scrollView.zoomScale == 1.0 else { return }

    let height = UIScreen.height
    let halfHeight = height / 2
    var alpha = CGFloat(1.0)

    switch pan.state {
    case .began: break
    case .changed:
      let translation = pan.translation(in: imageView.superview)

      // if x > y, means scroll to left or right
      let tx = abs(translation.x)
      let ty = abs(translation.y)
      if tx > ty { return }

      let y = pan.view!.center.y + translation.y
      // Calculator alpha
      alpha = y < halfHeight ? y / halfHeight : (height - y) / halfHeight

      // add 0.5 because don't want fast to transparent
      alpha += 0.5
      view.backgroundColor = .black.withAlphaComponent(alpha)
      // delegate?.panDidChanged(self, in: imageView, alpha: alpha)

      imageView.center = CGPoint(x: imageView.center.x, y: y)
      pan.setTranslation(.zero, in: imageView.superview)
    case .ended, .cancelled:
      if imageView.center != oriImageCenter {
        UIView.animate(withDuration: 0.3) {
          self.view.backgroundColor = .black
          self.imageView.center = self.oriImageCenter
        }
      }

    // delegate?.panDidEnded(self, in: imageView)
    default: break
    }
  }
}

// MARK: UIScrollViewDelegate

extension ZoomImageViewController: UIScrollViewDelegate {
  func viewForZooming(in _: UIScrollView) -> UIView? {
    imageView
  }

  func scrollViewDidZoom(_: UIScrollView) {
    imageView.center = centerOfContentSize
  }
}

// MARK: UIGestureRecognizerDelegate

extension ZoomImageViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
    return true
  }
}

// MARK: - ZoomImageScreen

struct ZoomImageScreen: UIViewControllerRepresentable {
  @Environment(\.dismiss) var dismiss
  @State var uiImage: UIImage?

  typealias UIViewControllerType = ZoomImageViewController

  func makeUIViewController(context: Context) -> ZoomImageViewController {
    let vc = ZoomImageViewController()
    vc.image = uiImage
    vc.delegate = context.coordinator
    return vc
  }

  func updateUIViewController(_: ZoomImageViewController, context _: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(dismiss)
  }

  class Coordinator: NSObject, @preconcurrency ZoomImageVCDelagate {
    var dismiss: DismissAction

    init(_ dismiss: DismissAction) {
      self.dismiss = dismiss
    }

    func singleTap(_: ZoomImageViewController) {}

    func panDidChanged(_: ZoomImageViewController, in _: UIView, alpha _: CGFloat) {}

    @MainActor func panDidEnded(_: ZoomImageViewController, in _: UIView) {
      dismiss()
    }
  }
}

// MARK: - ZoomImageVCDelagate

protocol ZoomImageVCDelagate: AnyObject {
  func singleTap(_ viewController: ZoomImageViewController)

  func panDidChanged(_ viewController: ZoomImageViewController, in targetView: UIView, alpha: CGFloat)

  func panDidEnded(_ viewController: ZoomImageViewController, in targetView: UIView)
}

#Preview {
  ZoomImageScreen(uiImage: UIImage(resource: .temple))
    .ignoresSafeArea()
}

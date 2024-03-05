//
//  SKPhotoBrowserRepresentable.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/5.
//

import Foundation
import SwiftUI
import SKPhotoBrowser

//struct SKPhotoBrowserRepresentable: UIViewControllerRepresentable {
//    @Binding var isPresented: Bool
//    var photos: [SKPhoto]
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let controller = UIViewController()
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        if isPresented && uiViewController.presentedViewController == nil {
//            let browser = SKPhotoBrowser(photos: photos)
//            uiViewController.present(browser, animated: true, completion: nil)
//        }
//    }
//}

import SwiftUI
import SKPhotoBrowser

//struct SKPhotoBrowserRepresentable: UIViewControllerRepresentable {
//    @Binding var isPresented: Bool
//    var photos: [SKPhoto]
//    var initialIndex: Int
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        // 创建一个容器UIViewController
//        let controller = UIViewController()
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        if isPresented && uiViewController.presentedViewController == nil {
//            // 使用initialIndex初始化SKPhotoBrowser
//            let browser = SKPhotoBrowser(photos: photos, initialPageIndex: initialIndex)
//            uiViewController.present(browser, animated: true, completion: nil)
//        }
//    }
//}


class SKPhotoBrowserHostingController: UIViewController {
    var photos: [SKPhoto]
    var initialIndex: Int

    init(photos: [SKPhoto], initialIndex: Int) {
        self.photos = photos
        self.initialIndex = initialIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let browser = SKPhotoBrowser(photos: photos, initialPageIndex: initialIndex)
        present(browser, animated: true, completion: nil)
    }
}


struct SKPhotoBrowserRepresentable: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var photos: [SKPhoto]
    var initialIndex: Int

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = SKPhotoBrowserHostingController(photos: photos, initialIndex: initialIndex)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 如果不需要更新逻辑，这里可以保持空实现
    }
}


class PhotoBrowserManager: ObservableObject {
    static let shared = PhotoBrowserManager()
    
    func showPhotos(from viewController: UIViewController, photos: [SKPhoto], initialIndex: Int = 0) {
        let browser = SKPhotoBrowser(photos: photos, initialPageIndex: initialIndex)
        viewController.present(browser, animated: true)
    }
}

extension View {
    func getRootViewController() -> UIViewController? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController
    }
    
    func showSKPhotoBrowser(photos: [SKPhoto], initialIndex: Int = 0) {
        if let viewController = getRootViewController() {
            PhotoBrowserManager.shared.showPhotos(from: viewController, photos: photos, initialIndex: initialIndex)
        }
    }
}

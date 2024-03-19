//
//  SKPhotoBrowserRepresentable.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/5.
//

import Foundation
import SwiftUI
import SKPhotoBrowser

class SKPhotoBrowserHostingController: UIViewController, SKPhotoBrowserDelegate {
    var photos: [SKPhoto]
    var initialIndex: Int
    
    var onDismiss: (() -> Void)? // 添加一个回调闭包，用于通知浏览器关闭

    init(photos: [SKPhoto], initialIndex: Int, onDismiss: (() -> Void)? = nil) {
        self.photos = photos
        self.initialIndex = initialIndex
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let browser = SKPhotoBrowser(photos: photos, initialPageIndex: initialIndex)
        browser.delegate = self // 设置代理
        present(browser, animated: true, completion: nil)
    }
    
    // SKPhotoBrowserDelegate方法
    func didDismissAtPageIndex(_ index: Int) {
        onDismiss?() // 当浏览器关闭时，调用闭包
    }
}


struct SKPhotoBrowserRepresentable: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var photos: [SKPhoto]
    var initialIndex: Int

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = SKPhotoBrowserHostingController(photos: photos, initialIndex: initialIndex) {
            isPresented = false // 当SKPhotoBrowser关闭时，更新isPresented状态
        }
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
    func showSKPhotoBrowser(photos: [SKPhoto], initialIndex: Int = 0) {
        if let viewController = UIApplication.shared.getCurrentViewController() {
            PhotoBrowserManager.shared.showPhotos(from: viewController, photos: photos, initialIndex: initialIndex)
        }
    }
}

//
//  SKPhotoBrowserRepresentable.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/5.
//

import Foundation
import SwiftUI
import SKPhotoBrowser

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
    func getCurrentViewController() -> UIViewController? {
        // 遍历所有的场景
        let activeScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        // 尝试找到第一个UIWindowScene并获取其keyWindow
        if let keyWindow = activeScenes.first?.windows
            .first(where: { $0.isKeyWindow }) {
            
            var currentViewController = keyWindow.rootViewController
            // 遍历presentedViewController来找到最上层的视图控制器
            while let presented = currentViewController?.presentedViewController {
                currentViewController = presented
            }
            return currentViewController
        }
        return nil
    }

    
    
    func showSKPhotoBrowser(photos: [SKPhoto], initialIndex: Int = 0) {
//        if let viewController = getRootViewController() {
//            debugPrint("viewController ==== \(viewController)")
//            PhotoBrowserManager.shared.showPhotos(from: viewController, photos: photos, initialIndex: initialIndex)
//        }
        if let viewController = getCurrentViewController() {
            debugPrint("viewController ==== \(viewController)")
            PhotoBrowserManager.shared.showPhotos(from: viewController, photos: photos, initialIndex: initialIndex)
        }
    }
}

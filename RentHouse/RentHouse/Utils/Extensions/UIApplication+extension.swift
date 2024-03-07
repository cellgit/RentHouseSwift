//
//  UIApplication+extension.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/7.
//

import Foundation
import SwiftUI

extension UIApplication {
    func getCurrentViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
            if let nav = base as? UINavigationController {
                return getCurrentViewController(base: nav.visibleViewController)
            } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
                return getCurrentViewController(base: selected)
            } else if let presented = base?.presentedViewController {
                return getCurrentViewController(base: presented)
            }
            return base
        }
    
    func getRootViewController() -> UIViewController? {
        // 遍历所有的场景
        let activeScenes = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
        
        // 尝试找到第一个UIWindowScene
        if let windowScene = activeScenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene {
            // 在这个windowScene中找到被标记为keyWindow的window
            if let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                // 获取并返回rootViewController
                return keyWindow.rootViewController
            }
        }
        // 如果找不到，返回nil
        return nil
    }
}

//
//  View+extension.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/4.
//

import Foundation
import SwiftUI

extension View {
    
    /// 侧滑dismiss视图
    /// - Parameter onDismiss: onDismiss
    /// - Returns: View
    func dragToDismiss(onDismiss: @escaping () -> Void) -> some View {
        self.modifier(DragToDismissModifier(onDismiss: onDismiss))
    }
}

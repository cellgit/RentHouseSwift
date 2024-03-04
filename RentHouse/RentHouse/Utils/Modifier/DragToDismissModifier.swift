//
//  DragToDismissModifier.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/4.
//

import Foundation
import SwiftUI

struct DragToDismissModifier: ViewModifier {
    var onDismiss: () -> Void
    
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 5, coordinateSpace: .local)
                    .onEnded { value in
                        let horizontalMove = value.translation.width
                        let verticalMove = value.translation.height
                        
                        if horizontalMove > 30 && abs(verticalMove) < 300 {
                            // 使用动画使得侧滑操作更加平滑
                            withAnimation {
                                onDismiss()
                            }
                        }
                    }
            )
    }
}

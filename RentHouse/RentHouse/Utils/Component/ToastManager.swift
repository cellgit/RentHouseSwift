//
//  Toast.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/5.
//

import Foundation
import SwiftUI

class ToastManager: ObservableObject {
    @Published var isShowing: Bool? = false
    @Published var message: String = ""
    @Published var type: ToastView.ToastType = .success
    
    var timer: Timer?
    
    func showToast(message: String, type: ToastView.ToastType, for duration: TimeInterval = 2) {
        self.message = message
        self.type = type
        isShowing = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            withAnimation {
                self.isShowing = false
            }
        }
    }
}


struct ToastView: View {
    let message: String
    let type: ToastType
    
    var body: some View {
        Text(message)
            .padding()
            .background(type.backgroundColor)
            .foregroundColor(type.textColor)
            .cornerRadius(20)
            .shadow(radius: 10)
    }
    
    enum ToastType {
        case success, error, warning
        
        var backgroundColor: Color {
            switch self {
            case .success: return Color.green.opacity(0.7)
            case .error: return Color.red.opacity(0.7)
            case .warning: return Color.yellow.opacity(0.7)
            }
        }
        
        var textColor: Color {
            switch self {
            case .warning: return Color.black
            default: return Color.white
            }
        }
    }
}


extension View {
    func toast(isPresented: Binding<Bool?>, content: () -> ToastView) -> some View {
        ZStack {
            self
            if ((isPresented.wrappedValue) != nil) {
                content()
                    .transition(.opacity)
                    .onTapGesture {
                        isPresented.wrappedValue = false
                    }
            }
        }
    }
}

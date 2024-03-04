//
//  KeyboardResponder.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/4.
//

import SwiftUI
import Combine

//class KeyboardResponder: ObservableObject {
//    @Published var keyboardHeight: CGFloat = 0
//    private var cancellables = Set<AnyCancellable>()
//
//    init() {
//        let keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
//            .map { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero }
//            .map { $0.height }
//
//        let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
//            .map { _ in CGFloat(0) }
//
//        Publishers.Merge(keyboardWillShow, keyboardWillHide)
//            .subscribe(on: RunLoop.main)
//            .assign(to: \.keyboardHeight, on: self)
//            .store(in: &cancellables)
//    }
//}

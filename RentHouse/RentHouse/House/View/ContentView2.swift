//
//  ContentView2.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/7.
//

import Foundation

import SwiftUI

struct ContentView2: View {
    @State private var showModal = false

    var body: some View {
        ZStack {
            // 主视图内容
            Button(action: {
                withAnimation {
                    showModal.toggle()
                }
            }) {
                Text("Show Modal")
            }

            // 条件性地展示模态视图
            if showModal {
                ModalView(showModal: $showModal)
                    .frame(width: 300, height: 500)
                    .background(Color.blue)
                    .cornerRadius(20)
                    .scaleEffect(showModal ? 1 : 0) // 控制缩放
                    .animation(.spring(), value: showModal) // 应用弹簧动画
            }
        }
    }
}

// 定义模态视图
struct ModalView: View {
    @Binding var showModal: Bool

    var body: some View {
        VStack {
            Button("Close") {
                withAnimation {
                    showModal = false
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(10)
        }
    }
}

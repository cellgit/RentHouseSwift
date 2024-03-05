//
//  RowViewStyle1.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/4.
//

import Foundation
import SwiftUI
import Combine

struct RowViewStyle1: View {
    var title: String
    @Binding var text: String
    var placeholder: String
    var onTapped: () -> Void
    
    
    var body: some View {
        Button(action: onTapped) {
            HStack {
                Text(title).bold()
                Spacer()
                Text(text.isEmpty ? placeholder : text)
                    .foregroundColor(text.isEmpty ? .gray : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading) // 确保Text在左侧
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.gray)
            }
        }
        .padding()
        .cornerRadius(5)
        .frame(maxWidth: .infinity) // 确保HStack填满父容器的宽度
    }
}

struct RowViewStyleWithInput: View {
    
    var title: String
    @Binding var text: String
    var placeholder: String
    var keyboardType: UIKeyboardType = .default // 添加键盘类型参数
    
    var body: some View {
        HStack {
            Text(title).bold()
            Spacer()
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType) // 设置键盘类型
                .foregroundColor(.primary) // 输入文本的颜色
                .padding(.leading, 0) // 在TextField左侧增加一些内边距
                .frame(height: 52) // 设置高度，确保有足够的点击区域
            Spacer()
        }
        .padding(.leading)
        .cornerRadius(5) // 圆角
        .frame(maxWidth: .infinity) // 确保HStack填满父容器的宽度
    }
}

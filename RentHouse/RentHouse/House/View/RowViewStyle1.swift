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
        .background(Color.white)
        .cornerRadius(5)
        //        .shadow(radius: 1)
        .frame(maxWidth: .infinity) // 确保HStack填满父容器的宽度
        
    }
}


import SwiftUI

struct RowViewStyleWithInput: View {
    
    //    var onTextChanged: (String) -> Void // 定义一个回调闭包
    
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
            //            Image(systemName: "chevron.right").foregroundColor(.gray)
        }
        .padding(.leading)
        .background(Color.white) // 背景色
        .cornerRadius(5) // 圆角
        //        .shadow(radius: 1) // 阴影
        .frame(maxWidth: .infinity) // 确保HStack填满父容器的宽度
    }
}



//struct RowViewWithInput: View {
//    var title: String
//    @Binding var text: String
//    var placeholder: String
//    var onTapped: () -> Void
//    
//    var body: some View {
//        Button(action: onTapped) {
//            HStack {
//                Text(title).bold()
//                Spacer()
//                // 使用TextField代替Text以允许用户输入
//                TextField(placeholder, text: $text)
//                    .foregroundColor(.primary) // 输入文本的颜色
//                    .frame(maxWidth: .infinity, alignment: .leading) // 确保TextField在左侧
//                Spacer()
//                Image(systemName: "chevron.right").foregroundColor(.gray)
//            }
//            .padding(.horizontal) // 为HStack添加水平方向的padding
//        }
//        .padding(.horizontal) // 为HStack添加水平方向的padding
//        .padding() // 为Button添加padding使得点击区域更大
//        .background(Color.white) // 背景颜色
//        .cornerRadius(5) // 圆角
//        .shadow(radius: 1) // 阴影
//        .frame(maxWidth: .infinity) // 确保HStack填满父容器的宽度
//    }
//}

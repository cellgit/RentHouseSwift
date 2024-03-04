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
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 1)
        
//        HStack {
//            Text(title)
//                .bold()
//            
//            Spacer()
//            
//            HStack {
//                Text(text.isEmpty ? placeholder : text)
//                    .foregroundColor(text.isEmpty ? .gray : .primary)
//                    .lineLimit(1)
//                    .frame(maxWidth: .infinity, alignment: .leading) // 确保Text在左侧
//                
//                Spacer() // 推动箭头向右对齐
//                
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.gray)
//            }
//            .onTapGesture {
//                onTapped() // 当点击这个区域时触发闭包
//            }
//            .frame(maxWidth: .infinity) // 确保HStack填满父容器的宽度
//            Spacer()
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(5)
//        .shadow(radius: 1)
    }
}

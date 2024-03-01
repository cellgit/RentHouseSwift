//
//  HouseDetailView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/27.
//

import SwiftUI

struct HouseDetailView: View {
    var house: House // 添加这行来声明一个House类型的变量

    var body: some View {
        VStack {
            Text(house.community ?? "") // 使用house对象的name属性
            // 在这里添加更多UI元素来展示房源的详细信息
        }
        .navigationTitle("房源详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    HouseDetailView(house: House(from: "示例房源" as! Decoder))
//}

//
//  MultiWrapFlowLayout.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/22.
//

import SwiftUI

struct MultiLabelFlowLayout: View {
    let items: [String]
    let spacing: CGFloat

    @State private var totalHeight = CGFloat.zero // 总高度，动态计算

    var body: some View {
        // 几何布局
        GeometryReader { geometry in
            self.content(in: geometry)
        }
        .frame(height: totalHeight) // 使用动态计算的高度
    }

    private func content(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return ZStack(alignment: .topLeading) {
            ForEach(self.items, id: \.self) { item in
                self.item(for: item)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > geometry.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == self.items.last {
                            width = 0
                        } else {
                            width -= d.width + self.spacing
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if item == self.items.last {
                            height = 0
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func item(for text: String) -> some View {
        Text(text)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.bg_unselected)
            .foregroundColor(.gray)
            .cornerRadius(6)
    }
    
    private func viewHeightReader(_ height: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let frame = geometry.frame(in: .local)
            DispatchQueue.main.async {
                height.wrappedValue = frame.size.height
            }
            return .clear
        }
    }
}

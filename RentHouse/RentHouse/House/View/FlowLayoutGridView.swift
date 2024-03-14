//
//  FlowLayoutGridView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/14.
//

import Foundation
import SwiftUI

class StringItemViewModel: ObservableObject {
    var items: [String] = []
    @Published var selectedItem: String? = nil

    init(items: [String]) {
        self.items = items
        self.selectedItem = items.first // 在这里设置默认选中第一个项目
    }
}

struct FlowLayoutGridView: View {
    let title: String
    @ObservedObject var viewModel: StringItemViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .bold()
                .padding(.horizontal, 16)

            WrapFlowLayout(items: viewModel.items, selectedItem: viewModel.selectedItem, spacing: 8) { item in
                print("\(item) was tapped")
                viewModel.selectedItem = viewModel.selectedItem == item ? nil : item
            }
            .padding(16)
        }
    }
}


struct WrapFlowLayout: View {
    let items: [String]
    let selectedItem: String?
    let spacing: CGFloat
    var tapAction: (String) -> Void

    @State private var totalHeight = CGFloat.zero // 总高度，动态计算

    var body: some View {
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
                            width = 0 // 最后一个元素，重置宽度
                        } else {
                            width -= d.width + self.spacing
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if item == self.items.last {
                            height = 0 // 最后一个元素，重置高度
                        }
                        return result
                    })
                    .onTapGesture {
                        tapAction(item)
                    }
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func item(for text: String) -> some View {
        Text(text)
            .padding()
            .background(Color(.secondarySystemFill))
            .foregroundColor(.gray)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selectedItem == text ? Color.blue : Color.clear, lineWidth: selectedItem == text ? 2 : 0)
            )
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


#Preview {
    
    FlowLayoutGridView(title: "租赁状态", viewModel: StringItemViewModel(items: ["可租", "预租", "已租", "已下架"]))
    
}

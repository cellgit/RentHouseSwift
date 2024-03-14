//
//  MultiFlowLayoutGridView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/14.
//

import SwiftUI

class MultiStringItemViewModel: ObservableObject {
    var items: [String] = []
    @Published var selectedItems: Set<String> = [] // 改为支持多选

    init(items: [String]) {
        self.items = items
        // 可以选择初始化时不选中任何项目，或选择默认选中的项目
    }
    
    // 添加或移除选中项的方法
    func toggleSelection(for item: String) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
    }
}

struct MultiFlowLayoutGridView: View {
    let title: String
    @ObservedObject var viewModel: MultiStringItemViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .bold()
                .padding(.horizontal, 16)

            MultiWrapFlowLayout(items: viewModel.items, selectedItems: viewModel.selectedItems, spacing: 8) { item in
                viewModel.toggleSelection(for: item) // 更新为多选逻辑
            }
            .padding(16)
        }
    }
}



struct MultiWrapFlowLayout: View {
    let items: [String]
    let selectedItems: Set<String> // 使用Set来支持多选
    let spacing: CGFloat
    var tapAction: (String) -> Void

    @State private var totalHeight = CGFloat.zero // 总高度，动态计算

    var body: some View {
        // 几何布局
        GeometryReader { geometry in
            self.content(in: geometry)
        }
        .frame(height: totalHeight) // 使用动态计算的高度
    }

    private func content(in geometry: GeometryProxy) -> some View {
        // 布局计算
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
                    // 修改这里来反映多选状态
                    .stroke(selectedItems.contains(text) ? Color.blue : Color.clear, lineWidth: selectedItems.contains(text) ? 2 : 0)
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

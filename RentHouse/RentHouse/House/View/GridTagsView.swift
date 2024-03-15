//
//  GridTagsView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/14.
//

import SwiftUI


//class GridTagsViewModel: ObservableObject {
//    var items: [String] = []
//    @Published var selectedItem: String? = nil
//
//    init(items: [String]) {
//        self.items = items
//        self.selectedItem = items.first // 在这里设置默认选中第一个项目
//    }
//}

struct GridTagsView: View {
    
    let title: String
    
    @ObservedObject var viewModel: StringItemViewModel
    
    let columns: [GridItem]
    
//    let columns: [GridItem] //= Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0, content: {
            
            Text("\(title)")
                .bold()
                .padding(.horizontal, 16)
            
            LazyVGrid(columns: columns, spacing: 8) {
                
                ForEach(viewModel.items, id: \.self) { item in
                    
                    Button(action: {
                        // 在这里定义点击后的操作
                        print("\(item) was tapped")
                        // 更新选中的项目
                        viewModel.selectedItem = viewModel.selectedItem == item ? nil : item
                    }) {
                        Text(item)
                            .padding() // 增加填充，让按钮更大，更易点击
                            .frame(maxWidth: .infinity) // 让按钮宽度扩展至最大
                            .background(Color.bg_unselected)
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(viewModel.selectedItem == item ? Color.blue_selected : Color.clear, lineWidth: viewModel.selectedItem == item ? 2 : 0)
                            )
                            .animation(.easeInOut, value: viewModel.selectedItem)
                            
                    }
                    
                }
                
            }
            .padding(16)
            
        })
        
    }
}

#Preview {
    
    GridTagsView(title: "租赁状态", viewModel: StringItemViewModel(items: ["可租", "预出租", "已出租", "已下架"]), columns: Array(repeating: .init(.flexible()), count: 3))
}

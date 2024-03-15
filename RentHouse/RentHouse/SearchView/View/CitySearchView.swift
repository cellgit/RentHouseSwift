//
//  CitySearchView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/4.
//

import SwiftUI


struct CitySearchView: View {
    var onSelect: (District) -> Void
    let onDismiss: () -> Void
    @StateObject var viewModel = CitySearchViewModel(service: SearchService())
    @State var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                if searchText.isEmpty {
                    groupedListView
                } else {
                    simpleListView
                        
                }
            }
            .navigationBarTitle("搜索所在城市", displayMode: .large)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "城市名")
            .onChange(of: searchText) { newValue in
                viewModel.fetchSearchCities(cityName: newValue)
            }
            .toolbar {
                // 添加自定义的返回按钮
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // 执行关闭视图的操作
                        onDismiss()
                    }) {
//                        Image(systemName: "chevron.backward")
//                            .imageScale(.large)
//                        Text("返回")
                        
                        Text("取消")
                    }
                }
            }
//            .dragToDismiss {
//                onDismiss()
//            }
        }
        
    }

    // 分组列表视图
    private var groupedListView: some View {
        List {
            ForEach(viewModel.sectionCityList, id: \.id) { section in
                Section(header: Text(section.sectionName ?? "未知").font(Font.system(size: 18, weight: .regular))) {
                    ForEach(section.cities, id: \.name) { item in
                        Button {
                            onSelect(item)
                            onDismiss()
                        } label: {
                            HStack {
                                Text(item.name ?? "")
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
            }
        }
    }

    // 简单列表视图
    private var simpleListView: some View {
        List(viewModel.cityList, id: \.name) { item in
            Button {
                onSelect(item)
                onDismiss()
            } label: {
                HStack {
                    Text(item.name ?? "")
                        .foregroundColor(.primary)
                }
            }
            
        }
    }
    
}


                        

//
//  CommunitySearchView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/4.
//

import SwiftUI
import MapKit

struct CommunityData {
    var name: String?
    
}

struct CommunitySearchView: View {
    
    public var latitude: CLLocationDegrees

    public var longitude: CLLocationDegrees
    
    var city: String
    
    
    var onSelected: (MKMapItem) -> Void
    let onDismiss: () -> Void
    
    @State private var searchResults = [MKMapItem]()
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            simpleListView
                .navigationBarTitle("搜索所在小区", displayMode: .large)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "请输入小区名称")
                .onChange(of: searchText) { newValue in
                    performSearch()
                }
                .onAppear {
                    performSearch()
                }
                .toolbar {
                    // 添加自定义的返回按钮
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            // 执行关闭视图的操作
                            onDismiss()
                        }) {
//                            Image(systemName: "chevron.backward")
//                                .imageScale(.large)
//                            Text("返回")
                            
                            Text("取消")
                        }
                    }
                }
        }
    }
    
    // 简单列表视图
    private var simpleListView: some View {
        VStack {
            List(searchResults, id: \.self) { item in
                Button {
                    onSelected(item)
                    onDismiss()
                } label: {
                    VStack(alignment: .leading) {
                        Text(item.name ?? "未知")
                            .foregroundColor(.primary)
                        Text(item.placemark.title ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    
    func performSearch() {
        let searchRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), // 示例中使用北京的坐标
                                              latitudinalMeters: 50000, longitudinalMeters: 50000)
        
        var midText = ""
        if searchText == "" {
            midText = "住宅"
        }
        
        MapSearchManager.shared.search(for: city + searchText + midText, region: searchRegion) { result in
            switch result {
            case .success(let mapItems):
                self.searchResults = mapItems
                
                mapItems.forEach { item in
                    debugPrint("item.name ===== \(item.name)")
                }
                debugPrint("phoneNumber: \(mapItems.first?.phoneNumber)")
                debugPrint("mapItems: \(mapItems.first?.description.decodedUnicode)")
            case .failure(let error):
                print("搜索失败: \(error.localizedDescription)")
            }
        }
    }
}

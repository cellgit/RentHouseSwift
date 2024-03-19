//
//  ProfileView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/27.
//

import SwiftUI
import MapKit

struct ProfileView: View {
    @EnvironmentObject var tabBarState: TabBarStateManager
    
    @State private var searchResults = [MKMapItem]()
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            TextField("搜索", text: $searchText, onCommit: performSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List(searchResults, id: \.self) { item in
                VStack(alignment: .leading) {
                    Text(item.name ?? "未知")
                    Text(item.placemark.title ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            withAnimation {
                tabBarState.visible = .visible
            }
        }
//        .onDisappear {
//            tabBarState.visible = .hidden
//        }
    }
    
    func performSearch() {
        let searchRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074), // 示例中使用北京的坐标
                                              latitudinalMeters: 50000, longitudinalMeters: 50000)
        MapSearchManager.shared.search(for: searchText, region: searchRegion) { result in
            switch result {
            case .success(let mapItems):
                self.searchResults = mapItems
                
                mapItems.forEach { item in
                    item.name
                }
                
//                debugPrint("phoneNumber: \(mapItems.first?.phoneNumber)")
//                debugPrint("mapItems: \(mapItems.first?.description.decodedUnicode)")
            case .failure(let error):
                print("搜索失败: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ProfileView()
}

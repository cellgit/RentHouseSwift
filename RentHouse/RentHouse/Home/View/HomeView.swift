//
//  HomeView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/27.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    
    @EnvironmentObject var tabBarState: TabBarStateManager
    
//    @ObservedObject var locationService = LocationService()
    @ObservedObject var cityDataManager = CityDataManager.shared
    @StateObject var viewModel = HomeViewModel(service: HomeService())
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                contentListView
            }
            .onAppear {
                withAnimation {
                    tabBarState.visible = .visible
                }
            }
//            .onDisappear {
//                tabBarState.visible = .hidden
//            }
            .navigationBarTitle("搜索", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    locationButton
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "小区/商圈/地铁站/地标")
        }
    }
    
    @ViewBuilder
    private var contentListView: some View {
        List {
            if viewModel.isLoading {
//                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let houses = viewModel.houses, !houses.isEmpty {
                ForEach(houses, id: \.id) { house in
                    NavigationLink(destination: HouseDetailView(model: house)) {
                        HouseCell(house: house)
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)").frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                emptyStateView
            }
        }
    }
    
    private var locationButton: some View {
        Button(action: {
            // 按钮点击事件
            print("用户头像被点击")
        }) {
            HStack {
                Image(systemName: "location.circle") //person.crop.circle
                    .imageScale(.large)
                
                let dict = UserDefaultsManager.get(forKey: UserDefaultsKey.selectedCity.key, ofType: [String:String].self)
                if let name = dict?["name"] {
                    Text(name)
                }
                
                if let cityInfo = cityDataManager.cityInfo as? [String: String] {
                    let name = cityInfo["name"] ?? ""
                    Text(name)
                }
            }
        }
    }
    
    var emptyStateView: some View {
        VStack {
            Spacer()
            Text("没有找到房源")
            Spacer()
        }
    }
    
    
}
 
struct HouseCell: View {
    var house: House
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading) {
                HStack {
                    
                    // 假设images数组不为空，加载第一张图片作为封面
//                    if let imageUrl = house.images?.first, let url = URL(string: imageUrl) {
//                        AsyncImage(url: url) { image in
//                            image.resizable()
//                                .aspectRatio(contentMode: .fill)
//                        } placeholder: {
//                            ProgressView()
//                        }
//                        .frame(width: 150, height: 93)
//                        .cornerRadius(16)
//                        .clipped() // 确保图片按照边界裁剪
//                    }
                    
                    
//                    if let imageUrl1 = house.images?.first {
//                        let imageUrl = imageUrl1 + thumb_900// thumb_heic_600// + thumb_400
//                        KFImage(URL(string: imageUrl))
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 150, height: 93)
//                            .cornerRadius(16)
//                            .clipped()
//                    }
                    
                    
                    
                    if let imageUrl1 = house.images?.first?.tiny?.url {
                        let imageUrl = imageUrl1 //+ thumb_heic_600// thumb_heic_600// + thumb_400
                        KFImage(URL(string: imageUrl))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 93)
                            .cornerRadius(16)
                            .clipped()
                    }
                    
                    VStack(alignment: .leading) {
                        Spacer(minLength: 0)
                        Text(house.community ?? "")
                            .font(.headline)
                        Spacer()
                        Text("价格: \(house.price ?? 0)元/月")
                            .font(.subheadline)
                        Spacer(minLength: 2)
                    }
                }
            }
        }
        
    }
}


#Preview {
    HomeView()
}





// 假设images数组不为空，加载第一张图片作为封面
//                    if let imageUrl = house.images.first, let url = URL(string: imageUrl) {
//                        AsyncImage(url: url) { image in
//                            image.resizable()
//                                .aspectRatio(contentMode: .fill)
//                        } placeholder: {
//                            ProgressView()
//                        }
//                        .frame(width: 150, height: 93)
//                        .cornerRadius(16)
//                        .clipped() // 确保图片按照边界裁剪
//                    }

//    var locationText: some View {
//
//        VStack {
//            if let location = locationService.location {
//                Text("位置: \(location.coordinate.latitude), \(location.coordinate.longitude)")
//            }
//            if let placemark = locationService.placemark {
//                Text("地点: \(placemark.locality ?? "未知"), \(placemark.country ?? "未知"), postalCode: \(placemark.subLocality ?? "未知")")
//                Text("administrativeArea: \(placemark.administrativeArea ?? "未知")")
//                Text("placemark: \(placemark)")
//            }
//            Button("获取位置") {
//                locationService.requestLocation()
//            }
//        }
//    }

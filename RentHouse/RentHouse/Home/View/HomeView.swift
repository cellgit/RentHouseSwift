//
//  HomeView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/27.
//

//    @State private var showCancelButton: Bool = false
//    @State private var showingCancel = false


import SwiftUI
import Kingfisher

struct HomeView: View {
    @ObservedObject var locationService = LocationService()
    @StateObject var viewModel = HomeViewModel(service: HomeService())
    @State private var searchText = ""
    @State private var showingCancel = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // 处理加载状态
                    if viewModel.isLoading {
                        VStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        // 使用实际的房源数据渲染列表
                    } else if let houses = viewModel.houses, !houses.isEmpty {
                        ForEach(houses, id: \.id) { house in
                            NavigationLink(destination: HouseDetailView(house: house)) {
                                HouseCell(house: house)
                            }
                        }
                        // 处理错误状态
                    } else if let errorMessage = viewModel.errorMessage {
                        VStack {
                            Spacer()
                            Text("Error: \(errorMessage)")
                            Spacer()
                        }
                        // 处理空数据状态
                    } else {
                        emptyStateView
                    }
                }
            }
            .navigationBarTitle(Text("搜索"), displayMode: .large)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
    
    
    
//    var body: some View {
//        NavigationView {
//            VStack {
//                if let location = locationService.location {
//                    Text("位置: \(location.coordinate.latitude), \(location.coordinate.longitude)")
//                }
//                if let placemark = locationService.placemark {
//                    Text("地点: \(placemark.locality ?? "未知"), \(placemark.country ?? "未知"), postalCode: \(placemark.subLocality ?? "未知")")
//                    Text("administrativeArea: \(placemark.administrativeArea ?? "未知")")
//                    Text("placemark: \(placemark)")
//                }
//                Button("获取位置") {
//                    locationService.requestLocation()
//                }
//            
//            
//                List {
//                    // 处理加载状态
//                    if viewModel.isLoading {
//                        VStack {
//                            Spacer()
//                            ProgressView()
//                            Spacer()
//                        }
//                        // 使用实际的房源数据渲染列表
//                    } else if let houses = viewModel.houses, !houses.isEmpty {
//                        ForEach(houses, id: \.id) { house in
//                            NavigationLink(destination: HouseDetailView(house: house)) {
//                                HouseCell(house: house)
//                            }
//                        }
//                        // 处理错误状态
//                    } else if let errorMessage = viewModel.errorMessage {
//                        VStack {
//                            Spacer()
//                            Text("Error: \(errorMessage)")
//                            Spacer()
//                        }
//                        // 处理空数据状态
//                    } else {
//                        emptyStateView
//                    }
//                }
//            }
//            .navigationTitle("房源列表")
//            .navigationBarHidden(false)
//        }
//    }
    
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
                    
                    if let imageUrl = house.images?.first {
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

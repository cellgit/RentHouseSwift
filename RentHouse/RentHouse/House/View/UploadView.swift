//
//  HouseUploadView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/28.
//

import Foundation
import SwiftUI
import Combine

struct RentalInfo {
    var city: String = ""
    var community: String = ""
    var address: String = ""
    var expectedRent: String = ""
}

struct UploadView: View {
    @State private var rentalInfo = RentalInfo()
    
    @ObservedObject var locationService = LocationService()
    @ObservedObject var cityDataManager = CityDataManager.shared
    @State private var searchText = ""
    @State private var showingCancel = false
    
    
    
    @StateObject var infoViewModel = HouseInfoViewModel()
    
    @StateObject var viewModel = HouseUploadViewModel()
    @State private var uploadResult: Bool?
    @State private var cancellables = Set<AnyCancellable>()
    
    //    @State private var images: [UIImage] = []
    @State private var images: [UIImage] = [UIImage.init(named: "009")!]
    @State private var price: Double = 2600
    @State private var rentalMethod: Int = 1
    @State private var lon: Double = 116.306121
    @State private var lat: Double = 40.052978
    @State private var province: String = "浙江省"
    @State private var city: String?
    @State private var district: String = "钱塘区"
    @State private var citycode: String = "0571"
    @State private var community: String?
    @State private var building: String = "17号楼"
    @State private var unit: String = "3"
    @State private var houseNumber: String = "501"
    @State private var roomNumber: String = "A"
    @State private var contact: String = "18298269622"
    @State private var status: Int = 1
    @State private var roomType: String = "1"
    @State private var floor: Int = 5
    @State private var totalFloors: Int = 17
    @State private var area: Double = 25
    @State private var orientation: String = "1"
    @State private var availableDate: String = "2024-03-22"
    @State private var leaseTerm: String = "1年"
    @State private var paymentMethod: String = ""
    @State private var decoration: String = ""
    @State private var desc: String = ""
    @State private var facilities: [String] = ["桌子", "椅子", "床", "空调", "热水器","冰箱"]
    @State private var tags: [String] = ["精装修", "近地铁", "带阳台"]
    @State private var petPolicy: Bool = false
    @State private var moveInRequirements: String = ""
    @State private var additionalFees: [String] = []
    
    @State private var combinedAddress: String = ""
    
    //    @State private var isNavigationActive = false
    
    @State private var isShowingSearchCommunityView = false
    @State private var isShowingSearchCityView = false
    
    
    //    let list = ["所在城市", "所在小区", "具体地址", "期望租金"]
    
    
    //    var body: some View {
    //
    //        HStack(alignment: .center, spacing: 8) {
    //
    //            Text("所在城市")
    //                .font(Font.system(size: 15, weight: .medium, design: .default))
    //                .padding(EdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 16))
    //
    //
    //
    //
    //
    //        }
    //
    //    }
    
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                List {
                    RowViewStyle1(title: "所在城市", text: Binding<String>(
                        get: { self.city ?? self.infoViewModel.city ?? "" },
                        set: { self.city = $0 }
                    ), placeholder: "选择房源所在的城市") {
                        self.isShowingSearchCityView = true
                    }
                    .fullScreenCover(isPresented: $isShowingSearchCityView, content: {
                        CitySearchView { district in
                            debugPrint("district ==== \(district.name)")
                        } onDismiss: {
                            self.isShowingSearchCityView = false
                        }
                    })
                    
                    
                    RowViewStyle1(title: "所在小区", text: Binding<String>(
                        get: { self.community ?? self.infoViewModel.community ?? "" },
                        set: { self.community = $0 }
                    ), placeholder: "请输入小区名称") {
                        self.isShowingSearchCommunityView = true
                    }
                    .fullScreenCover(isPresented: $isShowingSearchCommunityView, content: {
                        CommunitySearchView(latitude: infoViewModel.lat ?? lat, longitude: infoViewModel.lon ?? lon, city: self.city ?? self.infoViewModel.city ?? "")
                        { communityData in
                            debugPrint("communityData ==== \(communityData.name)")
                        } onDismiss: {
                            self.isShowingSearchCommunityView = false
                        }
                    })
                    
                    
                    RowViewStyle1(title: "具体地址", text: Binding<String>(
                        get: { self.community ?? self.infoViewModel.community ?? "" },
                        set: { self.community = $0 }
                    ), placeholder: "请输入门牌号") {
                        
                    }
                    
                    
                    // 为具体地址创建文本字段
                    TextField("楼房编号", text: $building)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("单元号", text: $unit)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("楼层", text: Binding<String>(
                        get: { String(self.floor) },
                        set: { self.floor = Int($0) ?? 0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("房号", text: $houseNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("房间号", text: $roomNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // 为期望租金创建文本字段
                    TextField("期望租金", text: Binding<String>(
                        get: { String(self.price) },
                        set: { self.price = Double($0) ?? 0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .navigationBarTitle(Text("发布房源"))
            .navigationBarTitleDisplayMode(.large)
            
            
            VStack {
                //            ProgressView(value: viewModel.uploadProgress)
                //                .progressViewStyle(LinearProgressViewStyle())
                //
                //            if let result = viewModel.responseData {
                //                let name = result.community
                //                Text("上传成功：\(name ?? "")")
                //
                //            }
                //            else if let error = viewModel.uploadError {
                //                Text("上传失败：\(error.localizedDescription)")
                //            }
                //            else {
                //                EmptyView()
                //            }
                
                
                
                
                
                Button("上传数据") {
                    
                    let router = HouseApi.uploadHouse(images: images,
                                                      price: price,
                                                      rentalMethod: rentalMethod,
                                                      lon: lon,
                                                      lat: lat,
                                                      province: province,
                                                      city: city ?? (infoViewModel.city ?? ""),
                                                      district: district,
                                                      citycode: citycode,
                                                      community: community ?? (infoViewModel.community ?? ""),
                                                      building: building,
                                                      unit: unit,
                                                      houseNumber: houseNumber,
                                                      roomNumber: roomNumber,
                                                      contact: contact,
                                                      status: status,
                                                      roomType: roomType,
                                                      floor: floor,
                                                      totalFloors: totalFloors,
                                                      area: area,
                                                      orientation: orientation,
                                                      availableDate: availableDate,
                                                      leaseTerm: leaseTerm,
                                                      paymentMethod: paymentMethod,
                                                      decoration: decoration,
                                                      desc: desc,
                                                      facilities: facilities,
                                                      tags: tags,
                                                      petPolicy: petPolicy,
                                                      moveInRequirements: moveInRequirements,
                                                      additionalFees: additionalFees)
                    
                    
                    viewModel.uploadData(router: router)
                }
            }
        }
    }
}



//@ObservedObject var locationService = LocationService()
//@ObservedObject var cityDataManager = CityDataManager.shared
//@StateObject var viewModel = HomeViewModel(service: HomeService())
//@State private var searchText = ""
//@State private var showingCancel = false

//var body: some View {
//    NavigationView {
//        VStack {
//            List {
//                // 处理加载状态
//                if viewModel.isLoading {
//                    VStack {
//                        Spacer()
//                        ProgressView()
//                        Spacer()
//                    }
//                    // 使用实际的房源数据渲染列表
//                } else if let houses = viewModel.houses, !houses.isEmpty {
//                    ForEach(houses, id: \.id) { house in
//                        NavigationLink(destination: HouseDetailView(house: house)) {
//                            HouseCell(house: house)
//                        }
//                    }
//                    // 处理错误状态
//                } else if let errorMessage = viewModel.errorMessage {
//                    VStack {
//                        Spacer()
//                        Text("Error: \(errorMessage)")
//                        Spacer()
//                    }
//                    // 处理空数据状态
//                } else {
//                    emptyStateView
//                }
//            }
//        }
//        .navigationBarTitle(Text("搜索"))
//        .navigationBarTitleDisplayMode(.large)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {
//                    // 按钮点击事件
//                    print("用户头像被点击")
//                }) {
//                    HStack {
//                        Image(systemName: "location.circle") //person.crop.circle
//                            .imageScale(.large)
//                        
//                        let dict = UserDefaultsManager.get(forKey: UserDefaultsKey.selectedCity.key, ofType: [String:String].self)
//                        if let name = dict?["name"] {
//                            Text(name)
//                        }
//                        
//                        if let cityInfo = cityDataManager.cityInfo as? [String: String] {
//                            let name = cityInfo["name"] ?? ""
//                            Text(name)
//                        }
//                    }
//                }
//            }
//            
//        }
//        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
//    }

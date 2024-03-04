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
    @State private var price: String = ""
    @State private var rentalMethod: String = "整租"
    @State private var lon: Double = 116.306121
    @State private var lat: Double = 40.052978
    @State private var province: String?
    @State private var city: String?
    @State private var district: String?
    @State private var citycode: String?
    @State private var community: String?
    @State private var building: String = ""
    @State private var unit: String = ""
    @State private var houseNumber: String = ""
    @State private var roomNumber: String = ""
    @State private var contact: String = "18298269622"
    @State private var status: Int = 1
    @State private var roomType: String = "1" // 租赁方式
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
    @State private var isShowingActionSheetOfRoomType = false
    
    //    @ObservedObject private var keyboardResponder = KeyboardResponder()
    
    @FocusState private var isTextFieldFocused: Bool
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                List {
                    
                    
                    RowViewStyle1(title: "城市", text: Binding<String>(
                        get: { self.city ?? self.infoViewModel.city ?? "" },
                        set: { self.city = $0 }
                    ), placeholder: "选择房源所在的城市") {
                        self.isShowingSearchCityView = true
                    }
                    .fullScreenCover(isPresented: $isShowingSearchCityView, content: {
                        CitySearchView { district in
                            self.isShowingSearchCityView = false
                            debugPrint("district ==== \(district.name)")
                            city = district.name
                            citycode = district.citycode
                        } onDismiss: {
                            self.isShowingSearchCityView = false
                        }
                    })
                    
                    RowViewStyle1(title: "小区", text: Binding<String>(
                        get: { self.community ?? self.infoViewModel.community ?? "" },
                        set: { self.community = $0 }
                    ), placeholder: "请输入小区名称") {
                        self.isShowingSearchCommunityView = true
                    }
                    .fullScreenCover(isPresented: $isShowingSearchCommunityView, content: {
                        CommunitySearchView(latitude: infoViewModel.lat ?? lat, longitude: infoViewModel.lon ?? lon, city: city ?? infoViewModel.city ?? "")
                        { item in
                            self.isShowingSearchCommunityView = false
                            community = item.name ?? ""
                            let placemark = item.placemark
                            lat = placemark.coordinate.latitude
                            lat = placemark.coordinate.longitude
                            province = placemark.administrativeArea // 省份
                            city = placemark.locality // 市
                            district = placemark.subLocality // 区县
                            
                            let subLocality = placemark.subLocality // 区县
                            let subThoroughfare = placemark.subThoroughfare // 街道
                            let administrativeArea = placemark.administrativeArea // 省份
                            let subAdministrativeArea = placemark.subAdministrativeArea
                            
                            //                            debugPrint("subThoroughfare ==== \(subThoroughfare), \(subLocality), \(administrativeArea), = \(subAdministrativeArea)")
                            
                        } onDismiss: {
                            self.isShowingSearchCommunityView = false
                        }
                    })
                    
                    
                    RowViewStyle1(title: "方式", text: $rentalMethod, placeholder: "请输入小区名称") {
                        isShowingSearchCommunityView = true
                    }
                    .onTapGesture {
                        isShowingActionSheetOfRoomType = true // 点击时显示ActionSheet
                    }
                    .actionSheet(isPresented: $isShowingActionSheetOfRoomType) { // ActionSheet的定义
                        ActionSheet(title: Text("选择租赁方式"), message: nil, buttons: [
                            .default(Text("整租")) { rentalMethod = "整租" },
                            .default(Text("合租")) { rentalMethod = "合租" },
                            .cancel()
                        ])
                    }
                    
                    RowViewStyleWithInput(title: "楼号", text: $building, placeholder: "请输入楼号,如1号楼输入: 1", keyboardType: .numberPad)
                        .focused($isTextFieldFocused)
                    RowViewStyleWithInput(title: "单元", text: $unit, placeholder: "请输入单元号,如2单元输入: 2", keyboardType: .numberPad)
                        .focused($isTextFieldFocused)
                    RowViewStyleWithInput(title: "房号", text: $houseNumber, placeholder: "请输入房号,如301单元输入: 301")
                        .focused($isTextFieldFocused)
                    if self.rentalMethod == "合租" {
                        RowViewStyleWithInput(title: "房间", text: $roomNumber, placeholder: "(选填)房间编码,如A房间: A")
                            .focused($isTextFieldFocused)
                    }
                    RowViewStyleWithInput(title: "租金", text: $price, placeholder: "如期望5000元,请输入: 5000", keyboardType: .decimalPad)
                        .focused($isTextFieldFocused)
                    
                    VStack {
                        Spacer()
                        FooterView {
                            onSubmit()
                        }
                        .padding()
                    }
                    .frame(height: 120, alignment: .center)
                    
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("完成") {
                            isTextFieldFocused = false
                        }
                    }
                }
                
            }
            .navigationBarTitle(Text("发布房源"))
            .navigationBarTitleDisplayMode(.large)
            
        }
    }
    
    func onSubmit() {
        
        if let result = viewModel.responseData {
            let name = result.community
            Text("上传成功：\(name ?? "")")
            
        }
        else if let error = viewModel.uploadError {
            Text("上传失败：\(error.localizedDescription)")
        }
        else {
            EmptyView()
        }
        
        let rentalMethodInt = rentalMethod == "整租" ? 1 : 2
        let priceDouble = Double(price) ?? 0
        let router = HouseApi.uploadHouse(images: images,
                                          price: priceDouble,
                                          rentalMethod: rentalMethodInt,
                                          lon: lon,
                                          lat: lat,
                                          province: province ?? "",
                                          city: city ?? (infoViewModel.city ?? ""),
                                          district: district ?? "",
                                          citycode: citycode ?? "",
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


struct FooterView: View {
    
    let onSubmit: () -> Void
    
//    init(onSubmit: @escaping () -> Void) {
//        self.onSubmit = onSubmit
//    }
    
    var body: some View {
        
        Button {
            print("提交按钮被点击")
            onSubmit()
        } label: {
            Text("提交")
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(16)
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

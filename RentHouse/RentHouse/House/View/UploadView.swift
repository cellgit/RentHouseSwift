//
//  HouseUploadView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/28.
//

import Foundation
import SwiftUI
import Combine

struct UploadView: View {
    
    @State private var keyboardHeight: CGFloat = 0
    
    @ObservedObject var uploadStateManager: UploadStateManager
    
    private var onDismiss: () -> Void
    
    // 修改初始化器以接受 UploadStateManager
    init(uploadStateManager: UploadStateManager, onDismiss: @escaping () -> Void) {
        self.uploadStateManager = uploadStateManager
        self.onDismiss = onDismiss
    }
    
    @ObservedObject private var locationService = LocationService()
    @ObservedObject private var cityDataManager = CityDataManager.shared
    @State private var searchText = ""
    @State private var showingCancel = false
    @StateObject var infoViewModel = HouseInfoViewModel()
    @StateObject var viewModel = HouseUploadViewModel()
    @State private var uploadResult: Bool?
    @State private var cancellables = Set<AnyCancellable>()
    @State private var images: [UIImage] = []
    @State private var price: String = ""
    @State private var rentalMethod: String = "整租"
    @State private var lon: Double? // = 116.306121
    @State private var lat: Double? // = 40.052978
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
    
    @State private var isShowingSearchCommunityView = false
    @State private var isShowingSearchCityView = false
    @State private var isShowingActionSheetOfRoomType = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var selectedImages: [UIImage] = []
    
    @State private var showingImagePicker = false
    
    private let maxImageCount = 9
    private var columns: Int = 3
    
    @StateObject private var toastManager = ToastManager()
    
    @StateObject var gridTagsViewModelOfStatus = StringItemViewModel(items: ["可租", "预租", "已租", "已下架"])
    
    @StateObject var gridTagsViewModelOfRoomType = StringItemViewModel(items: ["一室", "两室", "三室", "四室及以上"])
    /// 朝向
    @StateObject var gridTagsViewModelOfOrientation = StringItemViewModel(items: ["南", "北", "东", "西", "东南", "西南", "东北", "西北",])
    
    
    @StateObject var gridTagsViewModelOfOrientationFlowLayout = StringItemViewModel(items: ["南", "北", "东", "西", "东南", "西南", "东北", "西北",])
    
    let columns3: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    let columns4: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                ScrollView {
//                    ImagePickerCoordinatorView
                    ImageBrowserView(images: $images)
                    
                    RowViewStyle1(title: "城市", text: Binding<String>(
                        get: { self.city ?? self.infoViewModel.city ?? "" },
                        set: { self.city = $0 }
                    ), placeholder: "选择房源所在的城市") {
                        self.isShowingSearchCityView = true
                    }
                    .fullScreenCover(isPresented: $isShowingSearchCityView, content: {
                        CitySearchView { district in
                            self.isShowingSearchCityView = false
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
                        CommunitySearchView(latitude: lat ?? (infoViewModel.lat ?? 40.052978), longitude: lon ?? (infoViewModel.lon ?? 116.306121), city: city ?? infoViewModel.city ?? "")
                        { item in
                            self.isShowingSearchCommunityView = false
                            community = item.name ?? ""
                            let placemark = item.placemark
                            lat = placemark.coordinate.latitude
                            lon = placemark.coordinate.longitude
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
                    
                    
//                    GridTagsView(title: "租赁状态", items: ["可租", "预出租", "已出租", "已下架"])
                    
//                    GridTagsView(title: "房型", viewModel: gridTagsViewModelOfRoomType, columns: columns3)
//                        .id("房型")
//                        .padding(.vertical, 16)
//                    
//                    GridTagsView(title: "状态", viewModel: gridTagsViewModelOfStatus, columns: columns3)
//                        .id("状态")
//                        .padding(.vertical, 16)
//                    
//                    GridTagsView(title: "方向", viewModel: gridTagsViewModelOfOrientation, columns: columns4)
//                        .id("状态")
//                        .padding(.vertical, 16)
                    
                    
                    FlowLayoutGridView(title: "房型", viewModel: gridTagsViewModelOfRoomType)
                        .id("房型")
                        .padding(.vertical, 16)
                    
                    FlowLayoutGridView(title: "状态", viewModel: gridTagsViewModelOfStatus)
                        .id("状态")
                        .padding(.vertical, 16)
                    
                    
                    FlowLayoutGridView(title: "朝向", viewModel: gridTagsViewModelOfOrientationFlowLayout)
                    
                    
                    
                }
                .padding(8)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("完成") {
                            isTextFieldFocused = false
                        }
                    }
                }
                
                
                VStack {
                    Spacer()
                    FooterView {
                        onSubmit()
                    }
                    .padding()
                }
                .frame(height: 80, alignment: .center)
                
            }
            .navigationBarTitle(Text("发布房源"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        onDismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    })
                    
                }
            })
        }
//        .toast(isPresented: $toastManager.isShowing) {
//            ToastView(message: toastManager.message, type: toastManager.type)
//        }
    }
    
    func onSubmit() {
        // 确保之前的订阅被取消，避免重复订阅
        cancellables.removeAll()
        
        let rentalMethodInt = rentalMethod == "整租" ? 1 : 2
        let priceDouble = Double(price) ?? 0
        let router = HouseApi.uploadHouse(images: images,
                                          price: priceDouble,
                                          rentalMethod: rentalMethodInt,
                                          lon: lon ?? infoViewModel.lon ?? 116,
                                          lat: lat ?? infoViewModel.lat ?? 40,
                                          province: province ?? "",
                                          city: city ?? (infoViewModel.city ?? ""),
                                          district: district ?? "",
                                          citycode: citycode ?? (infoViewModel.citycode ?? ""),
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
        
        uploadStateManager.startUpload(router: router)
        
        onDismiss()
    }
    
}


struct FooterView: View {
    
    let onSubmit: () -> Void
    
        init(onSubmit: @escaping () -> Void) {
            self.onSubmit = onSubmit
        }
    
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
        .background(.blue)
        .foregroundColor(.white)
        .cornerRadius(16)
    }
}

//
//  HouseUploadView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/28.
//

import Foundation
import SwiftUI
import Combine
import BottomSheet
import PopupView

struct ActionSheetsState {
    var showingFirst = false
    var showingSecond = false
}

struct InputSheetsState {
    var showingFirst = false
}

struct UploadView: View {
    
    @Namespace var namespace
    
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
    @State private var paymentMethod: Int = 2//""
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
    
    @State private var isShowingActionSheetOfDate = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var selectedImages: [UIImage] = []
    
    @State private var showingImagePicker = false
    
    private let maxImageCount = 9
    private var columns: Int = 3
    
    @StateObject private var toastManager = ToastManager()
    
    @StateObject var gridTagsViewModelOfStatus = StringItemViewModel(items: ["可租", "已租", "预租", "已下架"])
    
    @StateObject var gridTagsViewModelOfRoomType = StringItemViewModel(items: ["一室", "两室", "三室", "四室及以上"])
    /// 朝向
    @StateObject var gridTagsViewModelOfOrientation = StringItemViewModel(items: ["南", "北", "东", "西", "东南", "西南", "东北", "西北",])
    
    @StateObject var gridTagsViewModelOfOrientationFlowLayout = StringItemViewModel(items: ["南", "北", "东", "西", "东南", "西南", "东北", "西北",])
    
    @StateObject var gridTagsViewModelOfDecoration = StringItemViewModel(items: ["简装", "精装", "豪华装修", "毛坯"])
    
    @StateObject var multiTagsViewModelOfPaymentMethod = MultiStringItemViewModel(items: ["季付", "月付", "半年付", "年付"])
    
    @StateObject var multiTagsViewModelOfFacilities = MultiStringItemViewModel(items: ["桌子", "椅子", "床", "空调", "冰箱", "热水器", "暖气", "燃气", "燃气灶"])
    
    @StateObject var multiTagsViewModelOfTags = MultiStringItemViewModel(items: ["精装修", "近地铁", "带阳台"])
    
    // 可租日期
    @StateObject private var dateViewModel = DateSelectionViewModel()
    
    let columns3: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    let columns4: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    @State var bottomSheetPosition: BottomSheetPosition = .hidden
    
    @State var actionSheets = ActionSheetsState()
    
    @State var videoURLs: [URL] = []
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    
                    ScrollView {
                        
                        ImageBrowserView(images: $images)
                        
                        VideoBrowserView(videoURLs: $videoURLs)
                        
                        RowViewStyle1(title: "城市", text: Binding<String>(
                            get: { self.city ?? self.infoViewModel.city ?? "" },
                            set: { self.city = $0 }
                        ), placeholder: "选择房源所在的城市") {
                            self.isShowingSearchCityView = true
                        }
//                        .fullScreenCover(isPresented: $isShowingSearchCityView, content: {
                        .sheet(isPresented: $isShowingSearchCityView, content: {
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
//                        .fullScreenCover(isPresented: $isShowingSearchCommunityView, content: {
                        .sheet(isPresented: $isShowingSearchCommunityView, content: {
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
                        
                        RowViewStyle1(title: "方式", text: $rentalMethod, placeholder: "请选择租赁方式") {
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
                        
                        VStack(alignment: .center, spacing: 8) {
                            FlowLayoutGridView(title: "房型", viewModel: gridTagsViewModelOfRoomType)
                                .id("房型")
                            //                            .padding(.vertical, 16)
                            FlowLayoutGridView(title: "状态", viewModel: gridTagsViewModelOfStatus)
                                .id("状态")
                            if gridTagsViewModelOfStatus.selectedItem == "预租" {
                                withAnimation(.snappy) {
                                    VStack {
                                        CustomDatePickerView(viewModel: dateViewModel)
                                            .background(Color.bg_unselected)
//                                            .background(Color(.secondarySystemBackground))
                                            .cornerRadius(16)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding([.bottom], 24)
                                    .matchedGeometryEffect(id: "calendar", in: namespace)
                                }
                            }
                            
                            FlowLayoutGridView(title: "朝向", viewModel: gridTagsViewModelOfOrientationFlowLayout)
                            
                            FlowLayoutGridView(title: "装修状况", viewModel: gridTagsViewModelOfDecoration)
                            
                            MultiFlowLayoutGridView(title: "付款方式", viewModel: multiTagsViewModelOfPaymentMethod)
                            
                            MultiFlowLayoutGridView(title: "设备配置", viewModel: multiTagsViewModelOfFacilities)
                            
                            MultiFlowLayoutGridView(title: "房源标签", viewModel: multiTagsViewModelOfTags)
                            
                        }
                        .padding(.vertical, 8)
                        
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
                            
//                            Task {
//                                await onSubmit()
//                            }
                        }
                        .padding()
                    }
                    .frame(height: 80, alignment: .center)
                    
                }
//                .padding(16)
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
            
        }
    }
    
    func onSubmit() {
        // 确保之前的订阅被取消，避免重复订阅
        cancellables.removeAll()
        
        let rentalMethodInt = rentalMethod == "整租" ? 1 : 2
        let priceDouble = Double(price) ?? 0
        // 租赁状态: 默认1
        let statusValue = HouseStatus(rawValue: gridTagsViewModelOfStatus.selectedItem ?? "可租")?.value() ?? 1
        // 房型: 默认为空字符
        let romTypeValue = RoomType(rawValue: gridTagsViewModelOfRoomType.selectedItem ?? "")?.value() ?? ""
        
        let roomOrientationValue = RoomOrientation(rawValue: gridTagsViewModelOfOrientation.selectedItem ?? "")?.value() ?? ""
        /// 付款方式
        let paymentMethods = PaymentMethodStruct().getPaymentMethods(multiTagsViewModelOfPaymentMethod.selectedItems)
        
        /// 装修状况: 默认简装
        let decorationValue = HouseDecoration(rawValue: gridTagsViewModelOfDecoration.selectedItem ?? "简装")?.value() ?? "1"
        let facilitiesList = Array(multiTagsViewModelOfFacilities.selectedItems)
        
        let tagList = Array(multiTagsViewModelOfTags.selectedItems)
        
        
        
        var selectedDateString: String = ""
        if statusValue == 3 { // 预租则选择的日期
            selectedDateString = "\(dateViewModel.selectedDate.timeIntervalSince1970)"
            debugPrint("selectedDate === \(selectedDateString) ===today== \(Date().timeIntervalSince1970)")
        }
        else if statusValue == 1 { // 可租,即今日
            selectedDateString = "\(Date().timeIntervalSince1970)"
        }
        else { // 已租和下架则没有日期
            selectedDateString = ""
        }
        
//        let router = HouseApi.uploadHouse(images: images,
//                                          videos: videoURLs,
//                                          price: priceDouble,
//                                          rentalMethod: rentalMethodInt,
//                                          lon: lon ?? infoViewModel.lon ?? 116,
//                                          lat: lat ?? infoViewModel.lat ?? 40,
//                                          province: province ?? "",
//                                          city: city ?? (infoViewModel.city ?? ""),
//                                          district: district ?? "",
//                                          citycode: citycode ?? (infoViewModel.citycode ?? ""),
//                                          community: community ?? (infoViewModel.community ?? ""),
//                                          building: building,
//                                          unit: unit,
//                                          houseNumber: houseNumber,
//                                          roomNumber: roomNumber,
//                                          contact: contact,
//                                          status: statusValue,
//                                          roomType: romTypeValue,
//                                          floor: floor,
//                                          totalFloors: totalFloors,
//                                          area: area,
//                                          orientation: roomOrientationValue,
//                                          availableDate: selectedDateString, //availableDate
//                                          leaseTerm: leaseTerm,
//                                          paymentMethod: paymentMethods,
//                                          //                                          paymentMethod: paymentMethod,
//                                          decoration: decorationValue,
//                                          desc: desc,
//                                          facilities: facilitiesList,
//                                          tags: tagList,
//                                          petPolicy: petPolicy,
//                                          moveInRequirements: moveInRequirements,
//                                          additionalFees: additionalFees)
//        
//        uploadStateManager.startUpload(router: router)
        
        uploadStateManager.upload(images: images,
                                  videos: videoURLs,
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
                                  status: statusValue,
                                  roomType: romTypeValue,
                                  floor: floor,
                                  totalFloors: totalFloors,
                                  area: area,
                                  orientation: roomOrientationValue,
                                  availableDate: selectedDateString, //availableDate
                                  leaseTerm: leaseTerm,
                                  paymentMethod: paymentMethods,
                                  //                                          paymentMethod: paymentMethod,
                                  decoration: decorationValue,
                                  desc: desc,
                                  facilities: facilitiesList,
                                  tags: tagList,
                                  petPolicy: petPolicy,
                                  moveInRequirements: moveInRequirements,
                                  additionalFees: additionalFees)
        
        
        onDismiss()
        
    }
    
    
//    func getVideoUrls(videos: [URL]) async -> [URL] {
//        var urls: [URL] = []
//        videos.forEach { url in
//            Task {
//                
//                let id = Date().timeIntervalSince1970
//                let outputHEVCURL = temporaryFileURL(fileName: "\(id)tempHEVCVideo.mp4")
//                let finalOutputURL = temporaryFileURL(fileName: "\(id)finalCompressedVideo.mp4")
//                
//                let result = await url.convertAndCompressVideo(inputURL: url, outputHEVCURL: outputHEVCURL, finalOutputURL: finalOutputURL, resolution: .res1080p)
//                
//                defer {
//                    // 无论成功还是失败，完成后都删除临时文件
//                    deleteFile(at: outputHEVCURL)
//                    deleteFile(at: finalOutputURL)
//                }
//                
//                switch result {
//                case .success(let url):
//                    print("Video processed successfully: \(url)")
//                    urls.append(url)
//                case .failure(let error):
//                    print("Error processing video: \(error.localizedDescription)")
//                }
//            }
//            
//        }
//        return urls
//    }
    
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

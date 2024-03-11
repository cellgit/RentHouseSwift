//
//  MyHousesView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/7.
//

import SwiftUI
import Kingfisher

struct MyHousesView: View {
    @ObservedObject var locationService = LocationService()
    @ObservedObject var cityDataManager = CityDataManager.shared
    @StateObject var viewModel = HomeViewModel(service: HomeService())
    @State private var searchText = ""
    @State private var showingCancel = false
    @State private var isPresentedUploadView = false
    
    @StateObject var uploadStateManager = UploadStateManager()
    
    @StateObject private var toastManager = ToastManager()
    
    // 将必要的UserDefaults数据提前加载到状态变量中
    @State private var selectedCityName: String?
    
    init() {
        // 加载选中的城市名称
        let dict = UserDefaultsManager.get(forKey: UserDefaultsKey.selectedCity.key, ofType: [String:String].self)
        _selectedCityName = State(initialValue: dict?["name"])
        
        if let cityInfo = cityDataManager.cityInfo as? [String: String] {
            _selectedCityName = State(initialValue: cityInfo["name"])
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // 在视图中使用
                if uploadStateManager.isUploading {
                    ProgressView("上传中...", value: uploadStateManager.uploadProgress, total: 1.0)
                }
                contentListView
            }
            .navigationBarTitle(Text("搜索"))
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "小区/商圈/地铁站/地标")
            .navigationBarItems(trailing: uploadButton)
            .toast(isPresented: $uploadStateManager.uploadSuccess) {
                if uploadStateManager.uploadSuccess == true {
                    ToastView.init(message: "上传成功", type: .success)
                }
                else {
                    ToastView.init(message: "上传失败,请重试", type: .error)
                }
            }
            
        }
    }
    
    @ViewBuilder
    private var contentListView: some View {
        List {
            if viewModel.isLoading {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let houses = viewModel.houses, !houses.isEmpty {
                ForEach(houses, id: \.id) { house in
                    NavigationLink(destination: HouseDetailView(house: house)) {
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
    
    private var uploadButton: some View {
        Button(action: {
            isPresentedUploadView = true
        }) {
            HStack {
                Image(systemName: "plus.square.fill.on.square.fill").imageScale(.large)
                if let name = selectedCityName {
                    Text(name)
                }
            }
        }
        .fullScreenCover(isPresented: $isPresentedUploadView) {
            UploadView(uploadStateManager: uploadStateManager) {
                isPresentedUploadView = false
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


#Preview {
    MyHousesView()
}

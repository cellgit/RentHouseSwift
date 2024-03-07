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
    
//    @ObservedObject var uploadStateManager = UploadStateManager()
    
    
    var body: some View {
        NavigationView {
            VStack {
                // 在视图中使用
                if uploadStateManager.isUploading {
                    ProgressView("上传中...", value: uploadStateManager.uploadProgress, total: 1.0)
                }
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
            .navigationBarTitle(Text("搜索"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                        // 按钮点击事件
                        print("用户头像被点击")
                        isPresentedUploadView = true
                        
                        
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill.on.square.fill")
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
                    .fullScreenCover(isPresented: $isPresentedUploadView, content: {
                        UploadView(uploadStateManager: uploadStateManager, onDismiss: {
                            isPresentedUploadView = false
                        })
                        .animation(.smooth, value: 1)
                    })
                    
                }
                
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "小区/商圈/地铁站/地标")
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

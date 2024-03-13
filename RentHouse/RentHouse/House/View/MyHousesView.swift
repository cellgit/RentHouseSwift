//
//  MyHousesView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/7.
//

import SwiftUI
import Kingfisher
//import WaterfallGrid

struct MyHousesView: View {
    @ObservedObject var locationService = LocationService()
    @ObservedObject var cityDataManager = CityDataManager.shared
    @StateObject var viewModel = HomeViewModel(service: HomeService())
    @State private var searchText = ""
    @State private var showingCancel = false
    @State private var isPresentedUploadView = false
    @State private var isShowingSearchCityView = false
    
//    @StateObject var uploadStateManager = UploadStateManager()
    
    @EnvironmentObject var progressHandler: ProgressHandler
    @StateObject var uploadStateManager: UploadStateManager
    
    @StateObject private var toastManager = ToastManager()
    
    // 将必要的UserDefaults数据提前加载到状态变量中
    @State private var selectedCityName: String?
    
    @State private var isSearchActive = false // 用于控制搜索激活状态
    
    @State private var isChangeListMode = false // 用于控制列表模式, false grid, true list
    
    init(progressHandler: ProgressHandler) {
//        self.progressHandler = progressHandler
        _uploadStateManager = StateObject(wrappedValue: UploadStateManager(progressHandler: progressHandler))
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
//                        ProgressView("上传中...", value: uploadStateManager.uploadProgress, total: 1.0)
                    }
                    if isChangeListMode {
                        contentListView
                            .transition(.asymmetric(insertion: .opacity.combined(with: .identity), removal: .opacity.combined(with: .identity)))
                    }
                    else {
                        List {
                            GridListView(viewModel: viewModel)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                        .transition(.asymmetric(insertion: .opacity.combined(with: .identity), removal: .opacity.combined(with: .identity)))
//                        .padding(.horizontal, 8)
                        .background(Color(.secondarySystemBackground))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: isChangeListMode)
                .navigationBarTitle(Text("搜索"))
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "小区/商圈/地铁站/地标")
                .onChange(of: searchText) { _ in
                    // 当搜索框被激活时，更新状态以触发动画
                    withAnimation {
                        isSearchActive = !searchText.isEmpty
                    }
                }
                .navigationBarItems(leading: locationButton)
                .navigationBarItems(trailing: changeListModeButton)
                .navigationBarItems(trailing: uploadButton)
        }
        .tabItem {
            Image(systemName: "magnifyingglass")
            Text("搜索")
        }
        
    }
    
    
    private var locationButton: some View {
        Button(action: {
            isShowingSearchCityView = true
        }) {
            HStack {
                if let name = selectedCityName {
                    Text(name)
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingSearchCityView, content: {
            CitySearchView { district in
                self.isShowingSearchCityView = false
                selectedCityName = district.name
                let citycode = district.citycode
            } onDismiss: {
                self.isShowingSearchCityView = false
            }
        })
    }
    
    private var uploadButton: some View {
        Button(action: {
            isPresentedUploadView = true
        }) {
            HStack {
                // plus.square.fill.on.square.fill
                Image(systemName: "plus.square.on.square").imageScale(.medium)
            }
        }
        .fullScreenCover(isPresented: $isPresentedUploadView) {
            UploadView(uploadStateManager: uploadStateManager) {
                isPresentedUploadView = false
            }
        }
    }
    
    private var changeListModeButton: some View {
        Button(action: {
            withAnimation {
                isChangeListMode.toggle()
            }
        }) {
            HStack {//"square.grid.2x2" : "list.dash"  "rectangle.grid.2x2" : "list.bullet.rectangle"
                Image(systemName: isChangeListMode ? "square.grid.2x2" : "list.dash").imageScale(.medium)
                    .animation(.spring, value: isChangeListMode)
            }
        }
    }
    
    @ViewBuilder
    private var contentListView: some View {
        List {
//            VStack {
                if viewModel.isLoading {
//                    ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let houses = viewModel.houses, !houses.isEmpty {
                    ForEach(houses, id: \.id) { house in
                        NavigationLink(destination: HouseDetailView(house: house)) {
                            HouseCell(house: house)
                        }
                    }
//                    .padding(.horizontal, -4)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)").frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    emptyStateView
                }
//            }
            
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

import SwiftUI
// 假设已经导入了SwiftUILayouts或者你有自己的实现

struct GridListView: View {
    @ObservedObject var viewModel: HomeViewModel
    var columns: Int = 2 // 可以根据需要调整列数

    var body: some View {
        ScrollView(.vertical) {
            if let houses = viewModel.houses, !houses.isEmpty {
                AnyLayout(VerticalWaterfallLayout(columns: columns)) {
                    ForEach(houses, id: \.id) { house in
                        NavigationLink(destination: HouseDetailView(house: house)) {
                            UploadHouseCell(house: house)
                        }
                    }
                }
            }
        }
        .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
//        .animation(.default, value: viewModel.houses)
    }
}


struct UploadHouseCell: View {
    let house: House // 假设House是你的模型类型
    // 假设你已经知道了图片的宽度和高度
    var body: some View {
        VStack {
//            if let image = house.images?.first?.tiny, let url = image.url, let imageWidth = image.width, let imageHeight = image.height {
//                KFImage(URL(string: url))
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .clipped()
//                    .layoutPriority(97)
//            }
            
            if let image = house.images?.first?.small, let url = image.url {
                KFImage(URL(string: url))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .layoutPriority(97)
            }
            
            
            HStack() {
                VStack(alignment: .leading) {
                    
                    Text(house.community ?? "")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.bottom, 8)
                        .fixedSize(horizontal: false, vertical: true)
                        .layoutPriority(98)
                    Text("\(house.price ?? 0)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .layoutPriority(99)
                }
                Spacer()
            }
            .padding([.leading, .trailing, .bottom], 8)
        }
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(10)
    }
}


//#Preview {
//    MyHousesView()
//}

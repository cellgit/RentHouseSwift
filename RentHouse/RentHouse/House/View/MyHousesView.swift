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
    
    @State private var isSearchActive = false // 用于控制搜索激活状态
    
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
                    
                    ScrollView(.vertical) {
                        GridListView(viewModel: viewModel)
                    }
                    .background(Color(.secondarySystemBackground))
                }
                .navigationBarTitle(Text("搜索"))
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "小区/商圈/地铁站/地标")
                .onChange(of: searchText) { _ in
                    // 当搜索框被激活时，更新状态以触发动画
                    withAnimation {
                        isSearchActive = !searchText.isEmpty
                    }
                }
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
        .tabItem {
            Image(systemName: "magnifyingglass")
            Text("搜索")
        }
        
    }
    
    
    
    // 将houses数组转换为每两个一组的新数组
    private func pairedHouses() -> [[House]] {
        guard let houses = viewModel.houses else {
            return []
        }
        var pairs = [[House]]()
        for i in stride(from: 0, to: houses.count, by: 2) {
            var pair = [houses[i]]
            if i + 1 < houses.count {
                pair.append(houses[i + 1])
            }
            pairs.append(pair)
        }
        return pairs
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

import SwiftUI
// 假设已经导入了SwiftUILayouts或者你有自己的实现

struct GridListView: View {
    @ObservedObject var viewModel: HomeViewModel
    var columns: Int = 2 // 可以根据需要调整列数

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let houses = viewModel.houses, !houses.isEmpty {
                    AnyLayout(VerticalWaterfallLayout(columns: columns)) {
                        ForEach(houses, id: \.id) { house in
                            NavigationLink(destination: HouseDetailView(house: house)) {
                                UploadHouseCell(house: house, width: (UIScreen.main.bounds.width-16-16-8) / CGFloat(columns))
                            }
                        }
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)").frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("没有找到房源").frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding(EdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16))
//            .padding(.horizontal, 10)
        }
        .animation(.default, value: columns)
        .animation(.default, value: viewModel.houses)
    }
}


//struct GridListView: View {
//    @ObservedObject var viewModel: HomeViewModel
//    private let columnSpacing: CGFloat = 5
//    private let rowSpacing: CGFloat = 8
//    private let padding: CGFloat = 16
//    private var columnWidth: CGFloat {
//        (UIScreen.main.bounds.width - columnSpacing - padding * 2) / 2
//    }
//
//    var body: some View {
//        ScrollView {
//            HStack(alignment: .top, spacing: columnSpacing) {
//                VStack(spacing: rowSpacing) {
//                    // Even indices
//                    ForEach(0..<numberOfItems(isEven: true), id: \.self) { index in
//                        if let house = viewModel.houses?[safe: index * 2] {
//                            NavigationLink(destination: HouseDetailView(house: house)) {
//                                UploadHouseCell(house: house, width: columnWidth)
//                            }
//                        }
//                    }
//                }
//
//                VStack(spacing: rowSpacing) {
//                    // Odd indices
//                    ForEach(0..<numberOfItems(isEven: false), id: \.self) { index in
//                        if let house = viewModel.houses?[safe: index * 2 + 1] {
//                            NavigationLink(destination: HouseDetailView(house: house)) {
//                                UploadHouseCell(house: house, width: columnWidth)
//                            }
//                        }
//                    }
//                }
//            }
//            .padding(.horizontal, padding)
//        }
//    }
//
//    private func numberOfItems(isEven: Bool) -> Int {
//        guard let houses = viewModel.houses else { return 0 }
//        let totalCount = houses.count
//        return isEven ? (totalCount + 1) / 2 : totalCount / 2
//    }
//}
//
//extension Array {
//    subscript(safe index: Index) -> Element? {
//        return indices.contains(index) ? self[index] : nil
//    }
//}



struct UploadHouseCell: View {
    let house: House // 假设House是你的模型类型
    let width: CGFloat // 接受宽度参数
    // 假设你已经知道了图片的宽度和高度
    var body: some View {
        VStack {
            if let image = house.images?.first?.tiny, let url = image.url, let imageWidth = image.width, let imageHeight = image.height {
                KFImage(URL(string: url))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: width * CGFloat(imageHeight) / CGFloat(imageWidth)) // 根据原始宽高比计算高度
                    .clipped()
            }
            
            Text(house.community ?? "")
                .font(.headline)
                .lineLimit(2) // 最多显示两行
                .fixedSize(horizontal: false, vertical: true) // 允许Text在垂直方向上根据内容调整大小
                .padding([.top, .bottom], 4)
            
            Text("价格: \(house.price ?? 0)元/月")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .background(Color.white)
        .cornerRadius(16)
//        .shadow(radius: 1)
        .padding(5)
    }
}


struct AnimatedSearchView<Content: View>: View {
    @Binding var isSearchActive: Bool
    let content: () -> Content

    var body: some View {
        VStack {
            content()
        }
        .offset(y: isSearchActive ? -100 : 0) // 根据搜索状态调整Y轴偏移量
        .animation(.smooth, value: isSearchActive) // 应用平滑动画效果
    }
}


#Preview {
    MyHousesView()
}







//@ViewBuilder
//private var contentListView: some View {
//    List {
//        if viewModel.isLoading {
//            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
//        } else if let houses = viewModel.houses, !houses.isEmpty {
//            ForEach(houses, id: \.id) { house in
//                NavigationLink(destination: HouseDetailView(house: house)) {
//                    HouseCell(house: house)
//                }
//            }
//        } else if let errorMessage = viewModel.errorMessage {
//            Text("Error: \(errorMessage)").frame(maxWidth: .infinity, maxHeight: .infinity)
//        } else {
//            emptyStateView
//        }
//    }
//}

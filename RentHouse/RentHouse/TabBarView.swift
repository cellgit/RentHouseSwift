//
//  TabBarView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/27.
//

import SwiftUI

class NavigationStateManager: ObservableObject {
    @Published var selectedTab: Int = 0
}



struct TabBarView: View {
    
    @StateObject var navigationStateManager = NavigationStateManager()
    
    // 用于追踪当前选中的Tab页
    @State private var selectedTab: Int = 0
    // 控制上传视图是否显示
    @State private var showingUploadView = false
    
    @EnvironmentObject var progressHandler: ProgressHandler
    
    
    var body: some View {
        
        
        TabView(selection: $navigationStateManager.selectedTab) {
            
            MyHousesView(progressHandler: progressHandler)
                .tabItem {
                    Image(systemName: "plus.square.fill.on.square.fill")
                    Text("上传房源")
                }
                .tag(0)
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("首页")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("我的")
                }
                .tag(2)
        }
        
    }
}

#Preview {
    TabBarView()
}

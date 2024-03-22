//
//  TabBarView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/27.
//

import SwiftUI

class NavigationStateManager: ObservableObject {
    @Published var selectedTab: Int = 0
//    @Published var hidden: Bool = false
}

class TabBarStateManager: ObservableObject {
    @Published var visible: Visibility = .visible
}



struct TabBarView: View {
    
    
    @StateObject var navigationStateManager = NavigationStateManager()
    
//    @StateObject var tabBarState = TabBarStateManager()
    
    // 用于追踪当前选中的Tab页
    @State private var selectedTab: Int = 0
    // 控制上传视图是否显示
    @State private var showingUploadView = false
    
    @EnvironmentObject var progressHandler: ProgressHandler
    
    @EnvironmentObject var tabBarState: TabBarStateManager
    
    
    
    var body: some View {
        
        //        TabView(selection: $navigationStateManager.selectedTab) {
        //
        //            // 为每个Tab单独添加NavigationView
        //            NavigationView {
        //                MyHousesView(progressHandler: progressHandler)
        //            }
        //            .tabItem {
        //                Image(systemName: "plus.square.fill.on.square.fill")
        //                Text("上传房源")
        //            }
        //            .tag(0)
        //
        //            NavigationView {
        //                HomeView()
        //            }
        //            .tabItem {
        //                Image(systemName: "house.fill")
        //                Text("首页")
        //            }
        //            .tag(1)
        //
        //            NavigationView {
        //                ProfileView()
        //            }
        //            .tabItem {
        //                Image(systemName: "person.fill")
        //                Text("我的")
        //            }
        //            .tag(2)
        //        }
        
        TabView(selection: $navigationStateManager.selectedTab) {
            
            MyHousesView(progressHandler: progressHandler)
                .tabItem {
                    Image(systemName: "plus.square.fill.on.square.fill")
                    Text("上传房源")
                }
                .tag(0)
//                .toolbar(tabBarState.visible, for: .tabBar)
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("首页")
                }
                .tag(1)
//                .toolbar(tabBarState.visible, for: .tabBar)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("我的")
                }
                .tag(2)
//                .toolbar(tabBarState.visible, for: .tabBar)
            
        }
        
    }
}

#Preview {
    TabBarView()
}



//        TabView {
//
//
//            MyHousesView(progressHandler: progressHandler)
//                .tabItem {
//                    Image(systemName: "plus.square.fill.on.square.fill")
//                    Text("上传房源")
//                }
//
//            HomeView()
//                .tabItem {
//                    Image(systemName: "house.fill")
//                    Text("首页")
//                }
//
//
//            ProfileView()
//                .tabItem {
//                    Image(systemName: "person.fill")
//                    Text("我的")
//                }
//        }

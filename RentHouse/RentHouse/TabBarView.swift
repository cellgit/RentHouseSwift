//
//  TabBarView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/27.
//

import SwiftUI

struct TabBarView: View {
    
    // 用于追踪当前选中的Tab页
        @State private var selectedTab: Int = 0
        // 控制上传视图是否显示
        @State private var showingUploadView = false
    
    
    var body: some View {
        
        
        ZStack(alignment: .bottom) {
            TabView {
                
                MyHousesView()
                    .tabItem {
                        Image(systemName: "plus.square.fill.on.square.fill")
                        Text("上传房源")
                    }
                
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("首页")
                    }
//                UploadView()
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("我的")
                    }
            }
            
        }
        
        
        
            
        
        
        
        
        
        
        
        
        
    }
}

#Preview {
    TabBarView()
}

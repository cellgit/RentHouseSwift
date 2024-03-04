//
//  TabBarView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/27.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            
            UploadView()
                .tabItem {
                    Image(systemName: "plus.square.fill.on.square.fill")
                    Text("上传房源")
                }
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("首页")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("我的")
                }
        }
    }
}

#Preview {
    TabBarView()
}

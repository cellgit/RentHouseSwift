//
//  RentHouseApp.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/27.
//

import SwiftUI

@main
struct RentHouseApp: App {
    
    // 监听系统的界面样式变化
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showingUploadView = false
    
    init() {
        CityDataManager.shared.startLocationAndFetchData()
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .background(Color(.systemBackground))
//                .accentColor(colorScheme == .dark ? .primary : .kleinBlue)
        }
    }
}

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
    
    init() {
        CityDataManager.shared.startLocationAndFetchData()
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
//                .accentColor(colorScheme == .dark ? .primary : .kleinBlue)
        }
    }
}

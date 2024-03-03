//
//  RentHouseApp.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/27.
//

import SwiftUI

@main
struct RentHouseApp: App {
    
    init() {
        CityDataManager.shared.startLocationAndFetchData()
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
    }
}

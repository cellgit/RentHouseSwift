//
//  HouseInfoViewModel.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/4.
//

import Foundation
//import Combine
import SwiftUI

class HouseInfoViewModel: ObservableObject {
    
    @ObservedObject var cityDataManager = CityDataManager.shared
    
    @Published var lon: Double?
    @Published var lat: Double?
    @Published var province: String?
    @Published var city: String?
    @Published var district: String?
    @Published var citycode: String?
    @Published var community: String?
    @Published var building: String?
    @Published var id: String?
    @Published var adcode: String?
    
    init() {
        getHouseInfo()
    }
    
    func getHouseInfo() {
        let dict = UserDefaultsManager.get(forKey: UserDefaultsKey.selectedCity.key, ofType: [String:String].self)
        if let name = dict?["name"] {
            self.city = name
            self.lon = Double(dict?["center"]?.split(separator: ",").first ?? "116.306121")
            self.lat = Double(dict?["center"]?.split(separator: ",").last ?? "40.052978")
            debugPrint("center ===== \(dict?["center"]), === \(self.lon), == \(self.lat) ")
        }
        
        citycode = dict?["citycode"]
        adcode = dict?["adcode"]
        id = dict?["id"]
        
        
        
        if let cityInfo = cityDataManager.cityInfo as? [String: String] {
            let name = cityInfo["name"] ?? ""
            self.city = name
            self.lon = Double(cityInfo["center"]?.split(separator: ",").first ?? "116.306121")
            self.lat = Double(cityInfo["center"]?.split(separator: ",").last ?? "40.052978")
            
            debugPrint("center ==2=== \(cityInfo["center"]), === \(self.lon), == \(self.lat) ")
        }
        
        
    }
    
    
}

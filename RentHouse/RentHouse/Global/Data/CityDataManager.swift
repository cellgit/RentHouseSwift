//
//  CityDataManager.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/3.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

class CityDataManager: ObservableObject {
    
    static let shared = CityDataManager()
    private var cancellables = Set<AnyCancellable>()
    @ObservedObject var locationService = LocationService()
    private let homeService = HomeService()
    
    @Published var cityInfo: [String: Any]?
    
    
    init() {
        // 监听placemark的变化
        locationService.$placemark
            .compactMap { $0 } // 确保placemark不为空
            .sink { [weak self] placemark in
                // 当placemark更新时执行的代码
                self?.placemarkUpdated(placemark: placemark)
                debugPrint("thoroughfare ==== \(placemark)")
            }
            .store(in: &cancellables)
    }
    
    func placemarkUpdated(placemark: CLPlacemark) {
        guard let locality = placemark.locality else { return }
        let coordinate = placemark.location?.coordinate
        let lat = coordinate?.latitude ?? 0
        let lon = coordinate?.longitude ?? 0
        fetchCityDataAndStoreCityCode(cityName: locality, using: homeService, lat: "\(lat)", lon: "\(lon)")
    }
    
    func startLocationAndFetchData() {
        locationService.requestLocation()
    }
    
    func fetchCityDataAndStoreCityCode(cityName: String, using homeService: HomeService, lat: String, lon: String) {
        homeService.fetchCities(name: cityName)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] districts in
                
                let center: String = "\(lon),\(lat)"
                let model = districts.first
                
                let info = ["center": center,
                            "citycode": model?.citycode ?? "",
                            "adcode": model?.adcode ?? "",
                            "name": model?.name ?? "",
                            "id": model?.id ?? ""
                ]
                
                
                
                UserDefaultsManager.save(info, forKey: UserDefaultsKey.selectedCity.key)
                let dict = UserDefaultsManager.get(forKey: UserDefaultsKey.selectedCity.key, ofType: [String:String].self)
                
                if let name = dict?["name"] {
                    if let currentName = model?.name, name != currentName {
                        debugPrint("当前选择的城市不是定位城市,是否需要修改")
                    }
                    else {
                        debugPrint("当前选择的城市是定位城市,不需要修改")
                    }
                }
                else {
                    debugPrint("当前选择的城市为空,需要新设置")
                    self?.cityInfo = info
                }
                
            })
            .store(in: &self.cancellables)
    }
    
}

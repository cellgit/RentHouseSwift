//
//  HomeService.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/28.
//

import Foundation
import Combine

class HomeService: HomeServiceProtocol {
    /// 搜索获取房源列表
    func fetchHouses(lon: String, lat: String, maxDistance: String) -> AnyPublisher<[House], Error> {
        NetworkManager.shared.request(HomeApi.searchHouses(lon, lat, maxDistance))
    }
    
    /// 搜索城市
    func fetchCities(name: String) -> AnyPublisher<[District], Error> {
        NetworkManager.shared.request(HomeApi.searchCities(name))
    }
}

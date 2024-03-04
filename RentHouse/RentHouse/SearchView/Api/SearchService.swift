//
//  SearchService.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/4.
//

import Foundation
import Combine

class SearchService: SearchServiceProtocol {
    /// 获取全国城市列表
    func fetchCityList() -> AnyPublisher<[CountryData], Error> {
        NetworkManager.shared.request(SearchApi.cityList)
    }
    
    
//    /// 获取全国城市列表
//    func fetchCityList() -> AnyPublisher<[District], Error> {
//        NetworkManager.shared.request(SearchApi.cityList)
//    }
    
    /// 搜索城市
    func fetchSearchCities(name: String) -> AnyPublisher<[District], Error> {
        NetworkManager.shared.request(SearchApi.searchCities(name))
    }
}

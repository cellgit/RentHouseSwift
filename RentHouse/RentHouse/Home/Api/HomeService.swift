//
//  HomeService.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/28.
//

import Foundation
import Combine

class HomeService: HomeServiceProtocol {
    func fetchHouses(lon: String, lat: String, maxDistance: String) -> AnyPublisher<[House], Error> {
        NetworkManager.shared.request(HomeApi.searchHouses(lon, lat, maxDistance))
    }
}

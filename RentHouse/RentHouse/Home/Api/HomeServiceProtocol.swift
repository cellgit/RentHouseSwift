//
//  HomeServiceProtocol.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/28.
//

//import Foundation
import Combine

protocol HomeServiceProtocol {
    func fetchHouses(lon: String,
                     lat: String,
                     maxDistance: String
    ) -> AnyPublisher<[House], Error>
}

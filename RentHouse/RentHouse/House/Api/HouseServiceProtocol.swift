//
//  HouseServiceProtocol.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/1.
//

import Combine
import UIKit

protocol HouseServiceProtocol {
//    func fetchHouses(lon: String,
//                     lat: String,
//                     maxDistance: String
//    ) -> AnyPublisher<[House], Error>
    
    func uploadHouse(images: [UIImage],
                     price: Double
    ) -> AnyPublisher<[House], Error>
    
}

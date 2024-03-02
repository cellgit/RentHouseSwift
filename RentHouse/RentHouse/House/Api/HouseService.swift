//
//  HouseService.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/1.
//

import Foundation
import Combine
import UIKit

//class HouseService: HouseServiceProtocol {
//    func uploadHouse(images: [UIImage], price: Double, rentalMethod: Int, lon: Double, lat: Double, province: String, city: String, district: String, citycode: String, community: String, building: String, unit: String, houseNumber: String, roomNumber: String, contact: String, status: Int, roomType: String, floor: Int, totalFloors: Int, area: Double, orientation: String, availableDate: String, leaseTerm: String, paymentMethod: String, decoration: String, desc: String, facilities: [String], tags: [String], petPolicy: Bool, moveInRequirements: String, additionalFees: [String]) -> AnyPublisher<[House], Never> {
//        
//        let router = HouseApi.uploadHouse(images: images,
//                                          price: price,
//                                          rentalMethod: rentalMethod,
//                                          lon: lon,
//                                          lat: lat,
//                                          province: province,
//                                          city: city,
//                                          district: district,
//                                          citycode: citycode,
//                                          community: community,
//                                          building: building,
//                                          unit: unit,
//                                          houseNumber: houseNumber,
//                                          roomNumber: roomNumber,
//                                          contact: contact,
//                                          status: status,
//                                          roomType: roomType,
//                                          floor: floor,
//                                          totalFloors: totalFloors,
//                                          area: area,
//                                          orientation: orientation,
//                                          availableDate: availableDate,
//                                          leaseTerm: leaseTerm,
//                                          paymentMethod: paymentMethod,
//                                          decoration: decoration,
//                                          desc: desc,
//                                          facilities: facilities,
//                                          tags: tags,
//                                          petPolicy: petPolicy,
//                                          moveInRequirements: moveInRequirements,
//                                          additionalFees: additionalFees)
//        
//        NetworkManager.shared.uploadWithProgress(router)
//    }
//    
//}

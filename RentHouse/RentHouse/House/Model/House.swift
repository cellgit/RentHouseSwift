//
//  House.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/28.
//

import Foundation


struct UploadHouseData: Decodable {
    var house: House?
}


struct ImageModel: Decodable {
    // 原图URL
    var original: String?
    // 中图URL
    var medium: String?
    // 小图URL
    var small: String?
    // 特小图
    var tiny: String?
    // 微图
    var micro: String?
}

// MARK: - House
struct House: Decodable {
//    var images: [String]?
    
    var images: [ImageModel]?
    var price: Int?
    var rentalMethod: Int?
    var community: String?
    var building: String?
    var province: String?
    var city: String?
    var district: String?
    var citycode: String?
    var unit: String?
    var houseNumber: String?
    var roomNumber: String?
    var status: Int?
    var paymentMethod: Int?
    var center: Center?
    var location: Location?
    var roomType: String?
    var area: Double?
    var floor: Int?
    var totalFloors: Int?
    var decoration: Int?
    var facilities: [String?]?
    var desc: String?
    var landlordId: String?
    var contact: String?
    var orientation: String?
    var reviewStatus: String?
    var tags: [String?]?
    var leaseTerm: String?
    var rating: Double?
    var availableDate: String?
    var petPolicy: Bool?
    var moveInRequirements: String?
    var publishDate: String?
    var reviews: [Review]?
    var additionalFees: [AdditionalFee]?
    var createdAt: String?
    var updatedAt: String?
    var id: String?
}

// MARK: - Center
struct Location: Decodable {
    var type: String?
    var coordinates: [Double]?
}

// MARK: - Location
struct Center: Decodable {
    var lat: Double?
    var lon: Double?
}

// MARK: - Review
struct Review: Decodable {
    var user: String?
    var rating: Double?
    var comment: String?
}

// MARK: - AdditionalFee
struct AdditionalFee: Decodable {
    var name: String?
    var amount: Double?
}

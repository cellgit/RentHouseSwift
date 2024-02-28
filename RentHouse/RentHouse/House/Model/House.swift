//
//  House.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/28.
//

import Foundation

// MARK: - House
struct House: Decodable {
    let images: [String]
    let price: Int
    let rentalMethod: Int
    let community: String
    let building: String
    let province: String
    let city: String
    let district: String
    let citycode: String
    let unit: String
    let houseNumber: String
    let roomNumber: String
    let status: Int
    let paymentMethod: Int
    let center: Center
    let location: Location
    let roomType: String
    let area: Double
    let floor: Int
    let totalFloors: Int
    let decoration: Int
    let facilities: [String?]
    let desc: String
    let landlordId: String
    let contact: String
    let orientation: String
    let reviewStatus: String
    let tags: [String?]
    let leaseTerm: String
    let rating: Double
    let availableDate: String
    let petPolicy: Bool
    let moveInRequirements: String
    let publishDate: String
    let reviews: [Review]
    let additionalFees: [AdditionalFee]
    let createdAt: String
    let updatedAt: String
    let id: String
}

// MARK: - Center
struct Center: Decodable {
    let type: String
    let coordinates: [Double]
}

// MARK: - Location
struct Location: Decodable {
    let lat: Double
    let lon: Double
}

// MARK: - Review
struct Review: Decodable {
    let user: String
    let rating: Double
    let comment: String
}

// MARK: - AdditionalFee
struct AdditionalFee: Decodable {
    let name: String
    let amount: Double
}


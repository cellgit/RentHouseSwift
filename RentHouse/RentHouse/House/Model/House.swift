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
    // URL
    var url: String?
    // 图片宽度
    var width: Double?
    // 图片高度
    var height: Double?
}


struct ImageGroupModel: Decodable, Identifiable {
    
    var id: UUID? = UUID() // 自动生成的UUID
    
    // 原图URL
    var original: ImageModel?
    // 中图URL
    var medium: ImageModel?
    // 小图URL
    var small: ImageModel?
    // 特小图
    var tiny: ImageModel?
    // 微图
    var micro: ImageModel?
}


struct VideoModel: Decodable {
    var originalVideo: ImageModel?
    var originalCoverImage: ImageModel?
}


extension House: Equatable {
    static func == (lhs: House, rhs: House) -> Bool {
        return lhs.id == rhs.id // 假设比较id属性即可判断两个House实例是否相等
    }
}
// MARK: - House
struct House: Decodable, Identifiable {
    /// 图片
    var images: [ImageGroupModel]?
    /// 视频
    var videos: [VideoModel]?
    /// 图片封面图
    var coverImage: ImageGroupModel?
    /// 视频封面图
    var coverVideoImage: ImageGroupModel?
    
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
    var paymentMethod: [String]?
    var center: Center?
    var location: Location?
    var roomType: String?
    var area: Double?
    var floor: Int?
    var totalFloors: Int?
    // 装修情况 (decoration)：1精装修、2简装修、3豪华装修、4毛坯房、5自定义内容
    var decoration: Int?
    // 配套设施 (facilities)：如家具、家电等配套情况
    var facilities: [String?]?
    var desc: String?
    var landlordId: String?
    var contact: String?
    var orientation: String?
    var reviewStatus: String?
    var tags: [String?]?
    // 租赁期限: 如果需要记录租赁的期限，可以添加一个字段来表示租赁的时长，如几个月或几年
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

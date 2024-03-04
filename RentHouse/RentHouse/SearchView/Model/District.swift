//
//  District.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/3.
//

import Foundation
import Foundation

// 省市区模型
struct District: Decodable {
    var citycode: String?
    var adcode: String?
    var center: String?
    var districts: [District]? // 假设districts数组里面是District类型的数据，我们需要定义这个类型，如果实际上它是空的或者其他类型，请相应地调整
    var level: String?
    var name: String?
    var updatedAt: String?
    var id: String?
    
    var sectionName: String?
}

//// 如果districts数组不为空，并且有具体的结构，你需要定义District模型。这里假设它是空的。
//struct District: Codable {
//    // 根据实际的districts数组里的对象结构定义属性
//}


// 获取全国城市数据的模型
struct CountryData: Decodable {
    var country: String
    var createdAt: String
    var districts: [CitySection]
}

// 定义地区数据模型
struct CitySection: Decodable {
    var id: Int?
    var sectionName: String?
    var cities: [District]
}

//// 定义城市数据模型，只包含一个可选的citycode
//struct City: Decodable {
//    var citycode: String?
//    var name: String?
//    var adcode: String?
//    var center: String?
//    // level = "city"
//    var level: String?
//    
//}

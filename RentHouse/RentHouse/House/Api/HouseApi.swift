//
//  HouseApi.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/1.
//

import Foundation
import Alamofire
import UIKit


enum HouseApi: ApiRouter {
    
    case uploadHouse(
        // 房源图片
        images: [UIImage],
        // 价格
        price: Double,
        // 租赁方式: 1整租、2合租
        rentalMethod: Int,
        // 坐标经度
        lon: Double,
        // 坐标纬度
        lat: Double,
        // 省份名
        province: String,
        // 城市名
        city: String,
        // 区/县名
        district: String,
        // 城市编码
        citycode: String,
        // 小区
        community: String,
        // 建筑编号
        building: String,
        // 单元号
        unit: String,
        // 房号
        houseNumber: String,
        // 房间号
        roomNumber: String,
        // 联系方式
        contact: String,
        // 租赁状态: 1出租中, 2已出租, 3已下架, 4预出租
        status: Int,
        // 房型
        roomType: String,
        // 房子所在楼层
        floor: Int,
        // 建筑物总楼层
        totalFloors: Int,
        // 房间面积
        area: Double,
        // 朝向
        orientation: String,
        // 可租日期
        availableDate: String,
        // 租期
        leaseTerm: String,
        // 付款方式：1押一付一、2押一付三、3押一付六、4押一付十二
        paymentMethod: String,
        // 装修情况 (decoration)：1精装修、2简装修、3豪华装修、4毛坯
        decoration: String,
        // 描述
        desc: String,
        // 设备配置
        facilities: [String],
        // 房源标签
        tags: [String],
        // 是否可养宠物
        petPolicy: Bool,
        // 房东硬性要求
        moveInRequirements: String,
        // // 附加费用
        additionalFees: [String]
    )
    
    // 定义路径
    private var path: String {
        switch self {
        case .uploadHouse:
            return "/user/house/add"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .uploadHouse:
            return .post
        }
    }
    
    private var encoding: ParameterEncoding {
        switch self {
//        case .uploadHouse(images: let images, price: _, rentalMethod: _, lon: _, lat: _, province: _, city: _, district: _, citycode: _, community: _, building: _, unit: _, houseNumber: _, roomNumber: _, contact: _, status: _, roomType: _, floor: _, totalFloors: _, area: _, orientation: _, availableDate: _, leaseTerm: _, paymentMethod: _, decoration: _, desc: _, facilities: _, tags: _, petPolicy: _, moveInRequirements: _, additionalFees: _):
//            
//            return images.isEmpty ? .json : .formData
        default:
            return .url
        }
    }
    
    // 创建共享构建函数
//    private func request(parameters: Parameters? = nil) -> RequestBuilder {
    private func request() -> RequestBuilder {
        RequestBuilder(baseURL: baseURL, path: path)
//            .with(parameters: parameters)
            .with(method: method)
            .with(encoding: encoding)
    }
    
    // 实现 builder 属性
    var builder: RequestBuilder {
        switch self {
        case .uploadHouse:
            return request()
        }
    }

    func configureMultipartFormData(_ formData: MultipartFormData) {
        guard case let .uploadHouse(
            images,
            price,
            rentalMethod,
            lon,
            lat,
            province,
            city,
            district,
            citycode,
            community,
            building,
            unit,
            houseNumber,
            roomNumber,
            contact,
            status,
            roomType,
            floor,
            totalFloors,
            area,
            orientation,
            availableDate,
            leaseTerm,
            paymentMethod,
            decoration,
            desc,
            facilities,
            tags,
            petPolicy,
            moveInRequirements,
            additionalFees
        ) = self else { return }
        
//        images.forEach { image in
////            let imageData1 = image.jpegData(compressionQuality: 1)
////            debugPrint("Not Optimized Image Size: \(String(describing: imageData1?.count))")
//            if let imageData = image.compress(to: 0.1) {
//                debugPrint("Optimized Image Size: \(imageData.count)")
//                formData.append(imageData, withName: "images", fileName: "house.jpg", mimeType: "image/jpeg")
//            }
//        }
        
        
        images.forEach { image in
            if let imageData = image.toHEIF(compressionQuality: 0.3) {
                debugPrint("Optimized Image Size: \(imageData.count)")
                formData.append(imageData, withName: "images", fileName: "house.heic", mimeType: "image/heic")
            }
        }
        
//        images.forEach { image in
//            if let imageData = image.toHEIFThenJPEG(compressionQualityForHEIF: 0.1, compressionQualityForJPEG: 0.1) {
//                debugPrint("Optimized Image Size: \(imageData.count)")
//                formData.append(imageData, withName: "images", fileName: "house.jpg", mimeType: "image/jpeg")
//            }
//        }
        
        let params = ["price": price,
                      "rentalMethod": rentalMethod,
                      "lon": lon,
                      "lat": lat,
                      "province": province,
                      "city": city,
                      "district": district,
                      "citycode": citycode,
                      "community": community,
                      "building": building,
                      "unit": unit,
                      "houseNumber": houseNumber,
                      "roomNumber": roomNumber,
                      "contact": contact,
                      "status": status,
                      "roomType": roomType,
                      "floor": floor,
                      "totalFloors": totalFloors,
                      "area": area,
                      "orientation": orientation,
                      "availableDate": availableDate,
                      "leaseTerm": leaseTerm,
                      "paymentMethod": paymentMethod,
                      "decoration": decoration,
                      "desc": desc,
                      "facilities": facilities,
                      "tags": tags,
                      "petPolicy": petPolicy,
                      "moveInRequirements": moveInRequirements,
                      "additionalFees": additionalFees
        ] as [String : Any]
        
        for (key, value) in params {
            if let valueString = value as? String, let data = valueString.data(using: .utf8) {
                formData.append(data, withName: key)
            }
            else if let val = value as? Int {
                formData.append("\(val)".data(using: .utf8)!, withName: key)
            }
            else if let val = value as? Double {
                formData.append("\(val)".data(using: .utf8)!, withName: key)
            }
            else if let arrayValue = value as? [String] {
                // 特别处理数组类型的字段
                arrayValue.forEach { item in
                    formData.append(item.data(using: .utf8)!, withName: key + "[]")
                }
            } else if let boolValue = value as? Bool {
                formData.append((boolValue ? "true" : "false").data(using: .utf8)!, withName: key)
            }
        }
    }
    
}

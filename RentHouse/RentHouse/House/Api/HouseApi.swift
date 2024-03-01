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
        images: [UIImage],
        price: Double,
        rentalMethod: Int,
        lon: Double,
        lat: Double,
        province: String,
        city: String,
        district: String,
        citycode: String
                     
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
        case .uploadHouse:
            return .formData
//        default:
//            return .json
        }
    }
    
    // 创建共享构建函数
    private func request(parameters: Parameters? = nil) -> RequestBuilder {
        RequestBuilder(baseURL: baseURL, path: path)
            .with(parameters: parameters)
            .with(method: method)
            .with(encoding: encoding)
    }
    
    // 实现 builder 属性
    var builder: RequestBuilder {
        switch self {
        case .uploadHouse(_, let price, let rentalMethod, let lon, let lat, let province, let city, let district, let citycode):
            let params = ["price": price,
                          "rentalMethod": rentalMethod,
                          "lon": lon,
                          "lat": lat,
                          "province": province,
                          "city": city,
                          "district": district,
                          "citycode": citycode
            ] as [String : Any]
            return request(parameters: params)
        }
    }

    func configureMultipartFormData(_ formData: MultipartFormData) {
        guard case let .uploadHouse(images, price, rentalMethod, lon, lat, province, city, district, citycode) = self else { return }
        
        images.forEach { image in
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                formData.append(imageData, withName: "images", fileName: "house.jpg", mimeType: "image/jpeg")
            }
        }
        
        let params = ["price": price,
                      "rentalMethod": rentalMethod,
                      "lon": lon,
                      "lat": lat,
                      "province": province,
                      "city": city,
                      "district": district,
                      "citycode": citycode
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
            
        }
    }
    
}





//enum HouseApi: ApiRouter {
//    
//    case uploadHouse(
//        images: [UIImage],
//        price: Double
//                     
//    )
//    
//    // 定义路径
//    private var path: String {
//        switch self {
//        case .uploadHouse:
//            return "/uploadHouse"
//        }
//    }
//    
//    private var method: HTTPMethod {
//        switch self {
//        case .uploadHouse:
//            return .post
//        }
//    }
//    
//    private var encoding: ParameterEncoding {
//        switch self {
//        case .uploadHouse:
//            return .json
////        default:
////            return .json
//        }
//    }
//    
//    // 创建共享构建函数
//    private func request(parameters: Parameters? = nil) -> RequestBuilder {
//        RequestBuilder(baseURL: baseURL, path: path)
//            .with(parameters: parameters)
//            .with(method: method)
//            .with(encoding: encoding)
//    }
//    
//    // 实现 builder 属性
//    var builder: RequestBuilder {
//        switch self {
//        case .uploadHouse(let images, let price):
//            let dict = ["price": price]
//            return request(parameters: dict)
//        }
//    }
//
//    func configureMultipartFormData(_ formData: MultipartFormData) {
//        guard case let .uploadHouse(images, price) = self else { return }
//        
//        images.forEach { image in
//            if let imageData = image.jpegData(compressionQuality: 0.5) {
//                formData.append(imageData, withName: "image", fileName: "house.jpg", mimeType: "image/jpeg")
//            }
//        }
//        
//        let params = ["price": price]
//        for (key, value) in params {
//            if let valueString = value as? String, let data = valueString.data(using: .utf8) {
//                formData.append(data, withName: key)
//            }
//        }
//    }
//    
//}

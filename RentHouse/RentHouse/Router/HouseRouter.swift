//
//  HouseRouter.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/27.
//

import Foundation
import Alamofire
import UIKit

enum HouseRouter: ApiRouter {
    
    case fetchHouses(parameters: Parameters)
    case createHouse(parameters: Parameters)
    case uploadHouse(parameters: [String: Any], image: [UIImage])
//    case uploadHouse(parameters: Parameters, image: [UIImage])
    
    // 定义路径
    private var path: String {
        switch self {
        case .fetchHouses:
            return "/houses"
        case .createHouse:
            return "/createHouse"
        case .uploadHouse:
            return "/uploadHouse"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .fetchHouses:
            return .post
        case .createHouse:
            return .post
        case .uploadHouse:
            return .post
        }
    }
    
    private var encoding: ParameterEncoding {
        switch self {
        case .uploadHouse:
            return .formData
        default:
            return .json
        }
    }
    
    // 创建共享构建函数
    private func makeRequest(parameters: Parameters? = nil) -> RequestBuilder {
        RequestBuilder(baseURL: baseURL, path: path)
            .with(parameters: parameters)
            .with(method: method)
            .with(encoding: encoding)
    }
    
    // 实现 builder 属性
    var builder: RequestBuilder {
        switch self {
        case .fetchHouses(let parameters), .createHouse(let parameters):
            return makeRequest(parameters: parameters)
        case .uploadHouse(let info, _):
            return makeRequest(parameters: info)
        }
    }

    func configureMultipartFormData(_ formData: MultipartFormData) {
        guard case let .uploadHouse(param, images) = self else { return }
        images.forEach { image in
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                formData.append(imageData, withName: "image", fileName: "house.jpg", mimeType: "image/jpeg")
            }
        }
        for (key, value) in param {
            if let valueString = value as? String, let data = valueString.data(using: .utf8) {
                formData.append(data, withName: key)
            }
        }
    }
    
}

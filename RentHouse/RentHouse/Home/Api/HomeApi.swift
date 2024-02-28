//
//  HomeApi.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/28.
//

import Foundation
import Alamofire

enum HomeApi: ApiRouter {
    case searchHouses(_ lon: String,
                      _ lat: String,
                      _ maxDistance: String)
    
    // 定义路径
    private var path: String {
        switch self {
        case .searchHouses:
            return "/serach/houses"
        }
    }
    
    
    private var method: HTTPMethod {
        switch self {
        case .searchHouses:
            return .post
        }
    }
    
    private var encoding: ParameterEncoding {
        switch self {
//        case .searchHouses:
//            return .json
        default:
            return .json
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
        case .searchHouses(let lon, let lat, let maxDistance):
            let location = ["lon": lon,
                            "lat": lat,
                            "maxDistance": maxDistance]
            let parameters = ["location": location]
            return request(parameters: parameters)
        }
    }
    
}

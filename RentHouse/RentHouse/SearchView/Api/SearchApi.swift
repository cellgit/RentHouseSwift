//
//  SearchApi.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/4.
//

import Foundation
import Alamofire

enum SearchApi: ApiRouter {
    case cityList
    
    case searchCities(_ name: String)
    
    
    // 定义路径
    private var path: String {
        switch self {
        case .cityList:
            return "/city/list"
        case .searchCities:
            return "/serach/cities"
        }
    }
    
    
    private var method: HTTPMethod {
        switch self {
        case .cityList:
            return .post
        case .searchCities:
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
        case .cityList:
            let parameters = ["keywords": "中国"]
            return request(parameters: parameters)
        case .searchCities(let name):
            let params = ["keyword": name]
            return request(parameters: params)
        }
    }
    
}

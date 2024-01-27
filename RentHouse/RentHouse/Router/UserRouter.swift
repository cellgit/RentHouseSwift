//
//  UserRouter.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/27.
//

import Foundation
import Alamofire
enum UserRouter: APIRouterProtocol {
    case getPhoneCode(parameters: Parameters)
    case login(parameters: Parameters)
    
    // 定义路径
    private var path: String {
        switch self {
        case .getPhoneCode:
            return "/getPhoneCode"
        case .login:
            return "/login"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getPhoneCode:
            return .post
        case .login:
            return .post
        }
    }
    
    private var encoding: ParameterEncoding {
        switch self {
        case .getPhoneCode:
            return .json
        case .login:
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
        case .getPhoneCode(let parameters):
            return makeRequest(parameters: parameters)
        case .login(let parameters):
            return makeRequest(parameters: parameters)
        }
    }
    
}

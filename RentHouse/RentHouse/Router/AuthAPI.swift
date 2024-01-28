//
//  UserRouter.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/27.
//

import Foundation
import Alamofire
enum AuthAPI: APIRouterProtocol {
    case sendCode(phone: String)
    case login(phone: String, code: String)
    
    // 定义路径
    private var path: String {
        switch self {
        case .sendCode:
            return "/sendCode"
        case .login:
            return "/login"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .sendCode:
            return .post
        case .login:
            return .post
        }
    }
    
    private var encoding: ParameterEncoding {
        switch self {
        case .sendCode:
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
        case .sendCode(let phone):
            let dict = ["phone": phone]
            return makeRequest(parameters: dict)
        case .login(let phone, let code):
            let dict = ["phone": phone, code: code]
            return makeRequest(parameters: dict)
        }
    }
    
}

//
//  APIRouterProtocol.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/27.
//

import Foundation
import Alamofire


protocol ApiRouter: URLRequestConvertible {
    var baseURL: URL { get }
    
    var builder: RequestBuilder { get }
    
    func configureMultipartFormData(_ formData: MultipartFormData)
}

extension ApiRouter {
    var baseURL: URL {
        URL(string: "http://47.116.24.54:3001/api/v1")!
    }
    
    func asURLRequest() throws -> URLRequest {
        let request = try builder.build()
        // 根据需要，这里可以添加其他通用逻辑
        return request
    }
    
    
    // 提供一个默认实现，这样只有需要的路由器会覆盖它
    func configureMultipartFormData(_ formData: MultipartFormData) {
        // 默认实现为空
    }
}

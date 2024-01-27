//
//  RequestBuilder.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/27.
//

import Foundation
import Alamofire

struct RequestBuilder {
    var baseURL: URL
    var path: String
    var method: HTTPMethod
    var parameters: Parameters?
    var headers: HTTPHeaders?
    var encoding: ParameterEncoding// = .json // 默认为 URL 编码
    var timeoutInterval: TimeInterval = 60  // 默认超时时间，例如60秒
    
    init(baseURL: URL, path: String, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, encoding: ParameterEncoding = .json) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.encoding = encoding
    }
    
    func build() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers ?? HTTPHeaders()
        request.timeoutInterval = timeoutInterval
        try encoding.encode(urlRequest: &request, with: parameters ?? Parameters())
        return request
    }
    
}

extension RequestBuilder {
    
    func with(method: HTTPMethod) -> RequestBuilder {
        var builder = self
        builder.method = method
        return builder
    }
    
    func with(parameters: Parameters?) -> RequestBuilder {
        var builder = self
        builder.parameters = parameters
        return builder
    }
    
    func with(headers: HTTPHeaders?) -> RequestBuilder {
        var builder = self
        builder.headers = headers
        return builder
    }
    
    func with(encoding: ParameterEncoding) -> RequestBuilder {
        var builder = self
        builder.encoding = encoding
        return builder
    }
    
    // ... 可以添加更多的链式方法 ...
}


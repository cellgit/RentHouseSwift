//
//  ParameterEncoder.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/27.
//

import Foundation
import Alamofire

let authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1ZGQ5YmRkYzMzMWRhYzc3ZmYwYTE5NyIsImlhdCI6MTcwOTAyMjE3MywiZXhwIjoxNzEyNjIyMTczfQ.bsU8zLnh6EgexlBKrWaUBmlFRGHpNt1H093dzZhUjkI"

enum EncodingError: String, Error {
    case missingURL = "The URL request is missing a URL."
    case encodingFailed = "Parameter encoding failed."
}


enum ParameterEncoding {
    case json
    case url
    case formData
    case custom(encoder: ParameterEncoder)
    
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        switch self {
        case .json:
            print("urlRequest: \(urlRequest) === \(parameters)")
            try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: parameters)
        case .url:
            try URLParameterEncoder().encode(urlRequest: &urlRequest, with: parameters)
        case .formData:
            try MultipartFormDataEncoder().encode(urlRequest: &urlRequest, with: parameters)
        case .custom(let encoder):
            try encoder.encode(urlRequest: &urlRequest, with: parameters)
        }
    }
}


protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

struct JSONParameterEncoder: ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.httpBody = jsonData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            }
        } catch {
            throw EncodingError.encodingFailed
        }
    }
}

struct URLParameterEncoder: ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw EncodingError.missingURL }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
    }
}


struct MultipartFormDataEncoder: ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        let boundary = "Boundary-\(UUID().uuidString)"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        urlRequest.httpBody = createBody(with: parameters, boundary: boundary)
    }
    
//    private func createBody(with parameters: Parameters, boundary: String) -> Data {
//        var body = Data()
//        
//        for (key, value) in parameters {
//            if let imageData = value as? Data, key.lowercased().contains("image") {
//                body.append("--\(boundary)\r\n")
//                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"image.jpg\"\r\n")
//                body.append("Content-Type: image/jpeg\r\n\r\n")
//                body.append(imageData)
//                body.append("\r\n")
//            } else if let videoData = value as? Data, key.lowercased().contains("video") {
//                body.append("--\(boundary)\r\n")
//                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"video.mp4\"\r\n")
//                body.append("Content-Type: video/mp4\r\n\r\n")
//                body.append(videoData)
//                body.append("\r\n")
//            } else {
//                body.append("--\(boundary)\r\n")
//                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.append("\(value)\r\n")
//            }
//        }
//        
//        body.append("--\(boundary)--\r\n")
//        return body
//    }
    
    private func createBody(with parameters: Parameters, boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            if let imageData = value as? Data {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"image.jpg\"\r\n")
                body.append("Content-Type: image/jpeg\r\n\r\n")
                body.append(imageData)
                body.append("\r\n")
            } else {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }
}

// Helper function to append string to Data
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


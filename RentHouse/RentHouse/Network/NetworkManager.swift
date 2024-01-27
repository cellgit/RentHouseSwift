//
//  NetworkManager.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/27.
//

import Foundation
import Alamofire

/*
 let houseRouter = HouseRouter.uploadHouse(info: info, image: image)
 NetworkManager.shared.upload(houseRouter, completion: { result in
 // 处理上传结果
 })
 */

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func request(_ urlConvertible: URLRequestConvertible) -> DataRequest {
        let request = AF.request(urlConvertible)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
        return request
    }

    func upload(_ router: APIRouterProtocol) -> UploadRequest {
        let request = AF.upload(multipartFormData: { formData in
            router.configureMultipartFormData(formData)
        }, with: try! router.builder.build())
        return request
    }
    
    func handleResponse<T: Decodable>(_ response: AFDataResponse<Data>, completion: @escaping (Result<T, Error>) -> Void) {
        switch response.result {
        case .success(let data):
            // ...处理成功情况...
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(NetworkError.decodingFailed(error: error)))
            }
        case .failure(let error):
            // 记录错误日志
            print("Network error: \(error.localizedDescription)")
//            completion(.failure(error))
            completion(.failure(NetworkError.networkError(error: error)))
        }
    }

    
    enum NetworkError: Error {
        case decodingFailed(error: Error)
        case networkError(error: Error)
    }
    
}

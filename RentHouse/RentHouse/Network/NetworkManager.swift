//
//  NetworkManager.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/27.
//

import Foundation
import Alamofire
import Combine

/*
 // 示例用法
 struct User: Decodable { ... }
 let userPublisher: AnyPublisher<User, Error> = NetworkManager.shared.request(MyAPIRouter.getUser)
 userPublisher.sink(receiveCompletion: { completion in
 switch completion {
 case .finished:
 // 处理成功完成
 break
 case .failure(let error):
 // 处理错误
 print(error)
 }
 }, receiveValue: { user in
 // 处理接收到的用户数据
 print(user)
 })
 .disposed(by: disposeBag)
 */

struct ApiResponse<T: Decodable>: Decodable {
    let code: Int?
    let message: String?
    let data: T?
}


struct JsonResponse: Decodable {
    let code: Int?
    let message: String?
}

enum NetworkError: Error, LocalizedError {
    case decodingError(error: Error)
    case networkError(error: Error)
    case serverError(message: String)
    case customError
    
    var errorDescription: String? {
        switch self {
        case .serverError(let message):
            return "Server error: \(message)"
        case .decodingError:
            return "Decoding error"
        case .networkError:
            return "networkError error"
        case .customError:
            return "An unknown error occurred"
        }
    }
    
}


class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    // 使用 Combine 处理请求
    func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) -> AnyPublisher<T, Error> {
        return AF.request(urlConvertible)
            .publishDecodable(type: ApiResponse<T>.self)
            .tryMap { result in
                switch result.result {
                case .success(let apiResponse):
                    // 检查响应码
                    if apiResponse.code == 200, let data = apiResponse.data {
                        return data
                    }
                    else if apiResponse.code == 200 {
                        return apiResponse as! T
                    }
                    else {
                        print("code码不是200 ==== \(apiResponse.code): \(apiResponse.message ?? "")")
                        throw NetworkError.serverError(message: apiResponse.message ?? "")
                    }
                case .failure(let error):
                    throw NetworkError.decodingError(error: error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // 使用 Combine 处理上传请求(不监听上传进度)
    func upload<T: Decodable>(_ router: APIRouterProtocol) -> AnyPublisher<T, Error> {
        return AF.upload(multipartFormData: { formData in
            router.configureMultipartFormData(formData)
        }, with: try! router.builder.build())
        .publishDecodable(type: T.self)
        .tryMap { result in
            switch result.result {
            case .success(let value):
                return value
            case .failure(let error):
                throw error
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    // 使用 Combine 处理带有进度监听的上传请求
    func uploadWithProgress<T: Decodable>(_ router: APIRouterProtocol, completion: @escaping (Result<T, Error>) -> Void) -> AnyPublisher<UploadProgress, Never> {
        
        let progressSubject = PassthroughSubject<UploadProgress, Never>()
        var progressTracker = UploadProgressTracker()
        let uploadRequest = AF.upload(multipartFormData: { formData in
            router.configureMultipartFormData(formData)
        }, with: try! router.builder.build())
        
        uploadRequest.uploadProgress { progress in
            let speed = progressTracker.calculateUploadSpeed(currentlyUploaded: progress.completedUnitCount)
            if let speed = speed {
                let uploadProgress = UploadProgress(
                    progress: progress.fractionCompleted,
                    isCompleted: false,
                    uploadSpeed: speed,  // 每秒上传的字节数
                    estimatedTimeRemaining: progress.estimatedTimeRemaining,  // 预计剩余时间
                    bytesUploaded: progress.completedUnitCount,  // 已上传的数据量
                    totalBytesToUpload: progress.totalUnitCount  // 总的上传数据量
                )
                progressSubject.send(uploadProgress)
            }
        }
        
        uploadRequest.responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
            
            // 在完成后发送完成的上传进度
            let finalProgress = UploadProgress(
                progress: 1.0,
                isCompleted: true,
                uploadSpeed: nil,
                estimatedTimeRemaining: nil,
                bytesUploaded: uploadRequest.uploadProgress.completedUnitCount,
                totalBytesToUpload: uploadRequest.uploadProgress.totalUnitCount
            )
            progressSubject.send(finalProgress)
            progressSubject.send(completion: .finished)
        }
        
        return progressSubject.eraseToAnyPublisher()
    }
}

struct UploadProgressTracker {
    private var lastUpdateTime = Date()
    private var lastUploadedBytes: Int64 = 0
    private let minTimeIntervalForSpeedUpdate: TimeInterval

    init(minTimeIntervalForSpeedUpdate: TimeInterval = 1.0) {
        self.minTimeIntervalForSpeedUpdate = minTimeIntervalForSpeedUpdate
    }

    mutating func calculateUploadSpeed(currentlyUploaded: Int64) -> Double? {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(lastUpdateTime)
        if elapsedTime >= minTimeIntervalForSpeedUpdate {
            let bytesUploadedSinceLastUpdate = currentlyUploaded - lastUploadedBytes
            let speed = Double(bytesUploadedSinceLastUpdate) / elapsedTime

            // 更新最后记录的时间和已上传字节
            lastUpdateTime = now
            lastUploadedBytes = currentlyUploaded

            return speed
        }
        return nil
    }
}


// UploadProgress 结构体定义
struct UploadProgress {
    var progress: Double  // 上传的进度，从 0.0 到 1.0
    var isCompleted: Bool = false  // 上传是否完成
    var uploadSpeed: Double?  // 每秒上传的字节数
    var estimatedTimeRemaining: TimeInterval?  // 预计剩余时间
    var bytesUploaded: Int64?  // 已上传的数据量
    var totalBytesToUpload: Int64?  // 总的上传数据量
    var error: Error?  // 发生的错误
    var serverResponse: Any?  // 服务器响应
}



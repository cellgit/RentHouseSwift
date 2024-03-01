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

/* 上传(有进度更新)
 NetworkManager.shared.uploadWithProgress(router)
     .sink(receiveValue: { (uploadResult: UploadResult<House>) in
         switch uploadResult {
         case .progress(let uploadProgress):
             // 处理上传进度
             print("Upload progress: \(uploadProgress.progress * 100)%")
             if let speed = uploadProgress.uploadSpeed {
                 print("Current speed: \(speed) bytes/sec")
             }
             if let timeRemaining = uploadProgress.estimatedTimeRemaining {
                 print("Estimated time remaining: \(timeRemaining) seconds")
             }
             
         case .completion(let result):
             // 处理完成后的响应数据
             switch result {
             case .success(let responseData):
                 // 成功解码响应数据
                 print("Upload successful with response: \(responseData)")
                 // 这里的responseData是T类型的实例，根据你的需求进行处理
                 
             case .failure(let error):
                 // 上传失败
                 print("Upload failed with error: \(error.localizedDescription)")
             }
         }
     })
     .store(in: &cancellables)
 
 */

/* 上传(无进度更新)
 NetworkManager.shared.upload(router)
     .sink(receiveCompletion: { completion in
         switch completion {
         case .finished:
             print("上传成功")
         case .failure(let error):
             print("上传失败: \(error.localizedDescription)")
         }
     }, receiveValue: { (houseData: House) in
         print("上传的图片ID: \(houseData.id), URL: \(houseData.price)")
     })
     .store(in: &cancellables)
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
                print("result ===== \(result)")
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
                        print("code码不是200 ==== \(String(describing: apiResponse.code)): \(apiResponse.message ?? "")")
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
    func upload<T: Decodable>(_ router: ApiRouter) -> AnyPublisher<T, Error> {
        return AF.upload(multipartFormData: { formData in
            router.configureMultipartFormData(formData)
        }, with: try! router.builder.build())
        .publishDecodable(type: ApiResponse<T>.self)
        .tryMap { result in
            print("result ===== \(result)")
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
                    print("code码不是200 ==== \(String(describing: apiResponse.code)): \(apiResponse.message ?? "")")
                    throw NetworkError.serverError(message: apiResponse.message ?? "")
                }
            case .failure(let error):
                throw NetworkError.decodingError(error: error)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func uploadWithProgress<T: Decodable>(_ router: ApiRouter) -> AnyPublisher<UploadResult<T>, Never> {
        let progressSubject = PassthroughSubject<UploadResult<T>, Never>()
        var progressTracker = UploadProgressTracker()

        let uploadRequest = AF.upload(multipartFormData: { formData in
            router.configureMultipartFormData(formData)
        }, with: try! router.builder.build())

        uploadRequest.uploadProgress { progress in
            let speed = progressTracker.calculateUploadSpeed(currentlyUploaded: progress.completedUnitCount)
            debugPrint("speed ===== \(String(describing: speed))")
            if let speed = speed {
                let uploadProgress = UploadProgress(
                    progress: progress.fractionCompleted,
                    isCompleted: false,
                    uploadSpeed: speed,
                    estimatedTimeRemaining: progress.estimatedTimeRemaining,
                    bytesUploaded: progress.completedUnitCount,
                    totalBytesToUpload: progress.totalUnitCount
                )
                progressSubject.send(.progress(uploadProgress))
            }
        }

        uploadRequest.publishDecodable(type: ApiResponse<T>.self)
            .tryMap { response in
                guard let apiResponse = response.value else {
                    throw NetworkError.decodingError(error: response.error ?? AFError.explicitlyCancelled)
                }
                if apiResponse.code == 200, let data = apiResponse.data {
                    return .completion(.success(data))
                } else {
                    throw NetworkError.serverError(message: apiResponse.message ?? "Unknown error")
                }
            }
            .catch { Just(.completion(.failure($0))) }
            .subscribe(Subscribers.Sink(receiveCompletion: { _ in },
                                        receiveValue: { progressSubject.send($0) }))

        return progressSubject.eraseToAnyPublisher()
    }
}

struct UploadProgressTracker {
    private var lastUpdateTime = Date()
    private var lastUploadedBytes: Int64 = 0
    private let minTimeIntervalForSpeedUpdate: TimeInterval

    init(minTimeIntervalForSpeedUpdate: TimeInterval = 0.5) {
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

enum UploadResult<T> {
    case progress(UploadProgress)
    case completion(Result<T, Error>)
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



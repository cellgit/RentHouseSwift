//
//  UploadStateManager.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/7.
//

import Foundation
import Combine

class UploadStateManager: ObservableObject {
    @Published var isUploading: Bool = false
    @Published var uploadProgress: Double = 0.0 // 0.0 to 1.0
    @Published var uploadSuccess: Bool? = nil // nil表示未完成，true表示成功，false表示失败
    @Published var uploadMessage: String = ""
    @Published var uploadError: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    var toastManager = ToastManager()
    
    
    func startUpload(router: ApiRouter) {
        
        uploadSuccess = nil
        cancellables.removeAll()
        isUploading = true
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shared.uploadWithProgress(router)
                .sink(receiveCompletion: { completion in
                    // 处理完成或失败
                    DispatchQueue.main.async {
                        switch completion {
                        case .finished:
                            break // 如果需要，这里可以处理完成后的逻辑
                        case .failure(let error):
                            self.uploadError = error
                            self.isUploading = false
                            self.uploadSuccess = false
                        }
                    }
                }, receiveValue: { [weak self] (uploadResult: UploadResult<House>) in
                    guard let self = self else { return }

                    DispatchQueue.main.async {
                        switch uploadResult {
                        case .progress(let uploadProgress):
                            // 处理上传进度
                            self.uploadProgress = uploadProgress.progress
                            // 其他进度更新逻辑
                        case .completion(let result):
                            // 处理完成后的响应数据
                            switch result {
                            case .success(let responseData):
                                // 成功逻辑处理
                                self.uploadSuccess = true
                                self.isUploading = false
                                self.toastManager.showToast(message: "上传成功", type: .success)
                            case .failure(let error):
                                // 失败逻辑处理
                                self.uploadError = error
                                self.isUploading = false
                                self.uploadSuccess = false
                                self.toastManager.showToast(message: "上传失败", type: .error)
                            }
                        }
                    }
                })
                .store(in: &self.cancellables)
        }

        
    }
    
    
    // 调用上传方法
//    func startUpload(router: ApiRouter) {
//        uploadSuccess = nil
//        cancellables.removeAll()
//        DispatchQueue.global(qos: .background).async {
//            NetworkManager.shared.uploadWithProgress(router)
//                .receive(on: RunLoop.main)
//                .sink(receiveValue: { [weak self] (uploadResult: UploadResult<House>) in
//                    guard let self = self else { return }
//                    
//                    switch uploadResult {
//                    case .progress(let uploadProgress):
//                        // 处理上传进度
//                        print("Upload progress: \(uploadProgress.progress * 100)%")
//                        self.uploadProgress = uploadProgress.progress
////                        self.uploadSuccess = uploadProgress.isCompleted
//                        if let speed = uploadProgress.uploadSpeed {
////                            self.uploadSpeed = speed
//                            print("Current speed: \(speed) bytes/sec")
//                        }
//                        if let timeRemaining = uploadProgress.estimatedTimeRemaining {
////                            self.estimatedTimeRemaining = timeRemaining
//                            print("Estimated time remaining: \(timeRemaining) seconds")
//                        }
//                    case .completion(let result):
//                        // 处理完成后的响应数据
//                        switch result {
//                        case .success(let responseData):
//                            // 成功解码响应数据
//                            print("Upload successful with response: \(responseData)")
//                            // 这里的responseData是T类型的实例，根据你的需求进行处理
////                            self.responseCompleted = true
//                            self.uploadSuccess = true
////                            self.responseData = responseData
//                            self.isUploading = false
////                            self.toastManager.showToast(message: "上传成功", type: .success)
//                        case .failure(let error):
//                            // 上传失败
//                            print("Upload failed with error: \(error.localizedDescription)")
////                            self.uploadError = error
//                            self.isUploading = false
//                            self.uploadSuccess = false
//                        }
//                    }
//                })
//                .store(in: &self.cancellables)
//        }
//        
//    }
    
}

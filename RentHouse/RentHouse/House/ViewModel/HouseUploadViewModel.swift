//
//  HouseUploadViewModel.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/28.
//

import Foundation
import Combine

class HouseUploadViewModel: ObservableObject {
    
    @Published var uploadResult: House?
    @Published var uploadError: Error?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var uploadProgress: Double = 0.0
    @Published var uploadSpeed: Double = 0.0
    @Published var uploadCompleted: Bool = false // 图片上传完成
    @Published var estimatedTimeRemaining: TimeInterval = 0.0
    @Published var responseCompleted: Bool = false // 响应结束,房源所有信息上传完成
    @Published var responseData: House?
    
    private var cancellables = Set<AnyCancellable>()

    // 调用上传方法
    func uploadData(router: ApiRouter) {
        NetworkManager.shared.uploadWithProgress(router)
            .sink(receiveValue: { (uploadResult: UploadResult<House>) in
                switch uploadResult {
                case .progress(let uploadProgress):
                    // 处理上传进度
                    print("Upload progress: \(uploadProgress.progress * 100)%")
                    self.uploadProgress = uploadProgress.progress
                    self.uploadCompleted = uploadProgress.isCompleted
                    if let speed = uploadProgress.uploadSpeed {
                        self.uploadSpeed = speed
                        print("Current speed: \(speed) bytes/sec")
                    }
                    if let timeRemaining = uploadProgress.estimatedTimeRemaining {
                        self.estimatedTimeRemaining = timeRemaining
                        print("Estimated time remaining: \(timeRemaining) seconds")
                    }
                case .completion(let result):
                    // 处理完成后的响应数据
                    switch result {
                    case .success(let responseData):
                        // 成功解码响应数据
                        print("Upload successful with response: \(responseData)")
                        // 这里的responseData是T类型的实例，根据你的需求进行处理
                        self.responseCompleted = true
                        self.responseData = responseData
                        
                    case .failure(let error):
                        // 上传失败
                        print("Upload failed with error: \(error.localizedDescription)")
                        self.uploadError = error
                    }
                }
            })
            .store(in: &cancellables)
        
    }
}

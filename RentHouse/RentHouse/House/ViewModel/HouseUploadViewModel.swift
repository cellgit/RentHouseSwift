//
//  HouseUploadViewModel.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/28.
//

import Foundation
import Combine

class HouseUploadViewModel: ObservableObject {
    @Published var uploadProgress: Double = 0.0
//    @Published var uploadCompleted: Bool = false
    @Published var uploadResult: House?
    @Published var uploadError: Error?
    
    @Published var house: House?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    

    // 调用上传方法
    func uploadData(router: ApiRouter) {
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
        
    }
}

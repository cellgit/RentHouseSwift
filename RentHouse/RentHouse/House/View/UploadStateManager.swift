//
//  UploadStateManager.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/7.
//

import Foundation
import Combine
import Drops
import UIKit
//import SwiftUI

class UploadStateManager: ObservableObject {
    @Published var isUploading: Bool = false
    @Published var uploadProgress: Double = 0.0 // 0.0 to 1.0
    @Published var uploadSuccess: Bool? = nil // nil表示未完成，true表示成功，false表示失败
    @Published var uploadMessage: String = ""
    @Published var uploadError: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    var progressHandler: ProgressHandler
    
    init(progressHandler: ProgressHandler) {
        self.progressHandler = progressHandler
    }
    
    
    func startUpload(router: ApiRouter) {
        
        uploadSuccess = nil
        cancellables.removeAll()
        isUploading = true
        
        // 上传时, 0则是在处理资源中..., 大于0小于1上传中,等于1上传完成,失败后设置为0.1
        self.uploadProgress(isUploading, progress: 0, status: .preparing)
        
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
                            //uploadProgress.progress >= 1
                            self.uploadProgress(self.isUploading, progress: uploadProgress.progress, status: .uploading)
                            
                            // 其他进度更新逻辑
                        case .completion(let result):
                            // 处理完成后的响应数据
                            switch result {
                            case .success(let responseData):
                                // 成功逻辑处理
                                self.uploadSuccess = true
                                self.isUploading = false
                                self.uploadAlert(true)
                                self.uploadProgress(self.isUploading, progress: 1, status: .success)
                            case .failure(let error):
                                // 失败逻辑处理
                                self.uploadError = error
                                self.isUploading = false
                                self.uploadSuccess = false
                                self.uploadAlert(false)
                                self.uploadProgress(self.isUploading, progress: 0.1, status: .failure)
                            }
                        }
                    }
                })
                .store(in: &self.cancellables)
        }

        
    }
    
    func uploadProgress(_ isVisiable: Bool, progress: CGFloat = 0, status: UploadProgressStatus) {
        switch status {
        case .preparing, .uploading:
            progressHandler.isVisible = isVisiable
        case .success, .failure:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.progressHandler.isVisible = isVisiable
            }
        case .none:
            progressHandler.isVisible = false
        }
        progressHandler.progress = progress // 或者根据实际情况更新进度
        progressHandler.uploadStatus = status
    }
    
    
    func uploadAlert(_ isSuccess: Bool) {
        if isSuccess {
            let drop = Drop(
                title: "上传成功",
                icon: UIImage.init(named: "checkmark.circle.pulse.byLayer"),
                action: .init {
                    print("Drop tapped")
                    Drops.hideCurrent()
                },
                position: .top,
                duration: 5.0,
                accessibility: "Alert: 上传成功, Subtitle"
            )
            Drops.show(drop)
        }
        else {
            let drop = Drop(
                title: "上传失败,请重试",
                icon: UIImage.init(named: "xmark.circle"),
                action: .init {
                    print("Drop tapped")
                    Drops.hideCurrent()
                },
                position: .top,
                duration: 5.0,
                accessibility: "Alert: 上传成功, Subtitle"
            )
            Drops.show(drop)
        }
        
    }
    
    
}

//
//  UploadStateManager.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/7.
//

import Foundation
import Combine
import JDStatusBarNotification
import Drops
import UIKit

class UploadStateManager: ObservableObject {
    @Published var isUploading: Bool = false
    @Published var uploadProgress: Double = 0.0 // 0.0 to 1.0
    @Published var uploadSuccess: Bool? = nil // nil表示未完成，true表示成功，false表示失败
    @Published var uploadMessage: String = ""
    @Published var uploadError: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
//    var toastManager = ToastManager()
    
    
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
                                self.uploadAlert(true)
                            case .failure(let error):
                                // 失败逻辑处理
                                self.uploadError = error
                                self.isUploading = false
                                self.uploadSuccess = false
                                self.uploadAlert(false)
                            }
                        }
                    }
                })
                .store(in: &self.cancellables)
        }

        
    }
    
    func uploadAlert(_ isSuccess: Bool) {
        if isSuccess {
            let drop = Drop(
                title: "上传成功",
                icon: UIImage.init(named: "checkmark.circle"),
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
                subtitle: "Subtitle",
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

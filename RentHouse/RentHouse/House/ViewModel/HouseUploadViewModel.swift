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
    @Published var uploadCompleted: Bool = false
    private var cancellables = Set<AnyCancellable>()

    // 调用上传方法
    func uploadData(router: APIRouterProtocol) {
        NetworkManager.shared.uploadWithProgress(router) { [weak self] (result: Result<House, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // 处理成功响应
                    self?.uploadCompleted = true
                    print("Upload Success: \(response)")
                case .failure(let error):
                    // 处理错误
                    print("Upload Error: \(error)")
                }
            }
        }
        .receive(on: RunLoop.main)
        .sink { progress in
            self.uploadProgress = progress.progress
        }
        .store(in: &cancellables)
    }
}

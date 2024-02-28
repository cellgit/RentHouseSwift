//
//  HouseUploadView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/28.
//

import Foundation
import SwiftUI

struct UploadView: View {
    @StateObject var viewModel = HouseUploadViewModel()

    var body: some View {
        VStack {
            ProgressView(value: viewModel.uploadProgress)
                .progressViewStyle(LinearProgressViewStyle())

            if let result = viewModel.uploadResult {
                let name = result.community
                Text("上传成功：\(name ?? "")")
                
            }
            else if let error = viewModel.uploadError {
                Text("上传失败：\(error.localizedDescription)")
            }
            else {
                EmptyView()
            }
            

            Button("上传数据") {
                let dict = ["name": "三室一厅"]
                let router = HouseRouter.uploadHouse(parameters: dict, image: [])  // 创建并配置您的 APIRouterProtocol 实例
                
                viewModel.uploadData(router: router)
            }
        }
    }
}

//
//  HouseUploadView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/28.
//

import Foundation
import SwiftUI
import Combine

struct UploadView: View {
    @StateObject var viewModel = HouseUploadViewModel()
    
    @State private var community = "多蓝水岸-"
    @State private var description = ""
    @State private var image: UIImage?
    @State private var uploadResult: Bool?
    @State private var cancellables = Set<AnyCancellable>()

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
                let image = UIImage.init(named: "009")!
                let router = HouseApi.uploadHouse(
                    images: [image],
                    price: 1000,
                    rentalMethod: 1,
                    lon: 116.306121,
                    lat: 40.052978,
                    province: "浙江省",
                    city: "杭州市",
                    district: "钱塘区",
                    citycode: "0571"
                )
                
                viewModel.uploadData(router: router)
            }
        }
    }
}

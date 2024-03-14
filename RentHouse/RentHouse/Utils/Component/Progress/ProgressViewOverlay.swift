//
//  ProgressViewOverlay.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/13.
//

import SwiftUI
import Combine

// 上传时, 0则是在处理资源中..., 大于0小于1上传中,等于1上传完成,失败后设置为0.1

struct ProgressViewOverlay: View {
    @EnvironmentObject var progressHandler: ProgressHandler

    var body: some View {
        if progressHandler.isVisible {
            switch progressHandler.uploadStatus {
            case .preparing, .uploading, .success, .failure:
                ZStack(alignment: .center) {
                    VStack {
                        MagicProgressView(isVisible: $progressHandler.isVisible, type: .circle(progress: $progressHandler.progress, lineWidth: 2.5, strokeColor: .green, backgroundColor: .gray))
                            .padding(4)
                            .frame(width: 28, height: 28, alignment: .center)
                            .foregroundColor(.green)
                    }
                    .edgesIgnoringSafeArea(.all) // 如果需要，可以忽略安全区域
                    UploadStatusView(status: $progressHandler.uploadStatus, progress: $progressHandler.progress)
                }
            case .none:
                EmptyView()
            }
        }
    }
}


//#Preview {
//    @EnvironmentObject var progressHandler: ProgressHandler
//    ProgressViewOverlay(progressHandler: _progressHandler)
//}

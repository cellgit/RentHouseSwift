//
//  ProgressViewOverlay.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/13.
//

import SwiftUI
import ProgressIndicatorView

// 上传时, 0则是在处理资源中..., 大于0小于1上传中,等于1上传完成,失败后设置为0.1

struct ProgressViewOverlay: View {
    @EnvironmentObject var progressHandler: ProgressHandler

    var body: some View {
        if progressHandler.isVisible {
            ZStack(alignment: .center) {
                VStack {
                    
//                    if progressHandler.isVisible == false {
//                        
//                        DispatchQueue.main.asyncAndWait {
//                            // 延迟一秒执行显示:
//                            ProgressIndicatorView(isVisible: $progressHandler.isVisible, type: .circle(progress: $progressHandler.progress, lineWidth: 2.5, strokeColor: .green, backgroundColor: Color(white: 0, opacity: 0.2)))
//                                .frame(height: 3.5)
//                               .foregroundColor(.green)
//                        }
//                    }
//                    else {
//                        
//                    }
                    
                    
                    ProgressIndicatorView(isVisible: $progressHandler.isVisible, type: .circle(progress: $progressHandler.progress, lineWidth: 2.5, strokeColor: .green, backgroundColor: Color(white: 0, opacity: 0.2)))
                        .frame(height: 3.5)
                       .foregroundColor(.green)
                    
                    
                    
                    // 根据需要添加更多定制化的视图样式
                }
                .frame(maxWidth: 20, maxHeight: 20)
                .background(Color.black.opacity(0.0))
                .edgesIgnoringSafeArea(.all) // 如果需要，可以忽略安全区域
                
                UploadStatusView(status: getStatus(progressHandler.progress, progressHandler.isVisible), progress: progressHandler.progress)
            }
            .frame(width: 30, height: 30, alignment: .center)
            
        }
    }
    
    
    func getStatus(_ progress: CGFloat, _ isVisiable: Bool) -> UploadProgressStatus {
        if isVisiable == false && progress > 0 { // 上传失败
            return .failure
        }
        else {
            
            if progress == 0 { // 准备中
                return .preparing
            }
            else if progress == 1 { // 上传成功
                return .success
            }
            else { // 上传中
                return .uploading
            }
        }
    }
    
}


//#Preview {
//    @EnvironmentObject var progressHandler: ProgressHandler
//    ProgressViewOverlay(progressHandler: _progressHandler)
//}

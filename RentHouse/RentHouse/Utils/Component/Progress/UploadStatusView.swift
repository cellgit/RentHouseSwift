//
//  UploadStatusView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/13.
//

extension CGFloat {
    var toPercentage: String {
        let percentageValue = self * 100
        return "\(Int(percentageValue))"
    }
}

enum UploadProgressStatus: Int8 {
    
    /// 初始化状态
    case none = 0
    /// 准备中,一般为处理资源中
    case preparing = 1
    /// 上传中,进度显示
    case uploading = 2
    /// 上传成功
    case success = 3
    /// 上传失败
    case failure = 4
}

import SwiftUI

struct UploadStatusView: View {
    /// 上传状态
    @Binding var status: UploadProgressStatus
    /// 上传进度
    @Binding var progress: CGFloat

    var body: some View {
        switch status {
        case .preparing:
            Image (systemName: "arrow.up" )
//                .phaseAnimator([false, true], content: { content, phase in
//                    content
//                        .foregroundColor(phase ? .green : .primary)
//                }, animation: { phase in
//                        .easeInOut(duration: 1.0)
//                })
                .phaseAnimator([false, true]) { content, phase in
                    content
                        .foregroundColor(phase ? .green : .blue)
                        .scaleEffect(phase ? 1 : 0.92)
                }
    //            .symbolEffect(.pulse, value: true)
                .font(Font.system(size: 12))
        case .uploading:
            Text("\(progress.toPercentage)%")
                .foregroundColor(.green)
                .font(Font.system(size: 7))
        case .success:
            Image (systemName: "checkmark" )
                .foregroundColor(.green)
    //            .symbolEffect(.pulse, value: true)
                .font(Font.system(size: 12))
        case .failure:
            Image (systemName: "xmark" )
                .foregroundColor(.red)
    //            .symbolEffect(.pulse, value: true)
                .font(Font.system(size: 12))
        case .none:
            EmptyView()
        }
    }
}



struct UploadSuccessSFSymbols : View {
    var body: some  View {
        Image (systemName: "checkmark.circle" )
            .foregroundColor(.green)
//            .symbolEffect(.pulse, value: true)
            .font(Font.system(size: 15))
    }
}

struct UploadFailureSFSymbols : View {
    var body: some  View {
        Image (systemName: "xmark.circle" )
            .foregroundColor(.red)
//            .symbolEffect(.pulse, value: true)
            .font(Font.system(size: 15))
    }
}


//#Preview {
//    UploadStatusView(status: .failure, progress: 0)
//}

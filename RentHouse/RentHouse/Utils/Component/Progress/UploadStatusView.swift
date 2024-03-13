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
    /// 准备中,一般为处理资源中
    case preparing = 0
    /// 上传中,进度显示
    case uploading = 1
    /// 上传成功
    case success = 2
    /// 上传失败
    case failure = 3
}

import SwiftUI

struct UploadStatusView: View {
    /// 上传状态
    @State var status: UploadProgressStatus
    /// 上传进度
    @State var progress: CGFloat

    var body: some View {
        VStack {
            UploadSFSymbols(status: $status, progress: $progress)
        }
    }
}

struct UploadSFSymbols : View {
    
    @Binding var status: UploadProgressStatus
    
    @Binding var progress: CGFloat
    
    var body: some  View {
        
        switch status {
        case .preparing:
            Image (systemName: "arrow.up" )
                .foregroundColor(.green)
    //            .symbolEffect(.pulse, value: true)
                .font(Font.system(size: 15))
        case .uploading:
            Text(progress.toPercentage)
        case .success:
            Image (systemName: "checkmark.circle" )
                .foregroundColor(.green)
    //            .symbolEffect(.pulse, value: true)
                .font(Font.system(size: 15))
        case .failure:
            Image (systemName: "xmark.circle" )
                .foregroundColor(.red)
    //            .symbolEffect(.pulse, value: true)
                .font(Font.system(size: 15))
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


#Preview {
    UploadStatusView(status: .failure, progress: 0)
}

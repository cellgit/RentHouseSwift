//
//  ImageViewer.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/19.
//

import SwiftUI
import Kingfisher

struct ImageViewer: View {
    
    let images: [String] // 图片名字存储在数组中
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            
            VStack(alignment: .center ,spacing: 0) {
                ForEach(images.indices, id: \.self) { index in
                    KFImage(URL(string: images[index]))
                        .placeholder { // 使用占位符
                            GeometryReader { screen in
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.3)
                                    .padding([.leading, .trailing], screen.size.width/3)
                                    .padding(.vertical, screen.size.height/3)
                            }
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 0.5)
                        .onTapGesture {
                            // 确保这个调用不会阻塞主线程
                            ImageBrowserManager.shared.showPhotoBrowser(images: ImageSource.urls(images), at: index)
                        }
                }
            }
        }
    }
    
}

#Preview {
    
    let url1 = "http://tanhua2120.oss-cn-shanghai.aliyuncs.com/rental/coverImages/original/65dd9bddc331dac77ff0a197/20240318-1809b4a5-house_cover.heic"
    
    let url2 = "http://tanhua2120.oss-cn-shanghai.aliyuncs.com/rental/coverImages/original/65dd9bddc331dac77ff0a197/20240318-e62de906-house_cover.heic"
    
    let url3 = "http://tanhua2120.oss-cn-shanghai.aliyuncs.com/rental/coverImages/original/65dd9bddc331dac77ff0a197/20240318-a20bec6f-house_cover.heic"
    
    return ImageViewer(images: [url1, url2, url3])
}

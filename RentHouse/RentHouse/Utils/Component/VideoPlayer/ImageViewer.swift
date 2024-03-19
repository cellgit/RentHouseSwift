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
            VStack(spacing: 0) {
                ForEach(images.indices, id: \.self) { index in
                    KFImage(URL(string: images[index]))
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 0.5)
                        .onTapGesture {
                            ImageBrowserManager.shared.showPhotoBrowser(images: ImageSource.urls(images), at: index)
                        }
                }
            }
        }
        
    }
}


//struct ImageViewer: View {
//    
//    let images: [String] // 图片名字存储在数组中
//    
//    @State private var scale: CGFloat = 1.0
//    
//    @State private var isShowImageBrowser: Bool = false
//    
//    @State private var selectedIndex: Int = 0
//    
//    var body: some View {
//        ScrollView(.vertical, showsIndicators: true) {
//            VStack(spacing: 0) {
//                ForEach(images.indices, id: \.self) { index in
//                    KFImage(URL(string: images[index]))
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 0.5)
//                        .onTapGesture {
////                            ImageBrowserManager.shared.showPhotoBrowser(images: ImageSource.urls(images), at: index)
//                            isShowImageBrowser = true
//                            selectedIndex = index
//                        }
//                }
//                
//                ImageBrowser(isPresented: $isShowImageBrowser, images: ImageSource.urls(images), index: selectedIndex)
//            }
//        }
//        
//    }
//}

#Preview {
    
    let url1 = "http://tanhua2120.oss-cn-shanghai.aliyuncs.com/rental/coverImages/original/65dd9bddc331dac77ff0a197/20240318-1809b4a5-house_cover.heic"
    
    let url2 = "http://tanhua2120.oss-cn-shanghai.aliyuncs.com/rental/coverImages/original/65dd9bddc331dac77ff0a197/20240318-e62de906-house_cover.heic"
    
    let url3 = "http://tanhua2120.oss-cn-shanghai.aliyuncs.com/rental/coverImages/original/65dd9bddc331dac77ff0a197/20240318-a20bec6f-house_cover.heic"
    
    return ImageViewer(images: [url1, url2, url3])
}

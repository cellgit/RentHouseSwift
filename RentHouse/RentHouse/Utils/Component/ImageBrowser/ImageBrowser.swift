//
//  ImageBrowser2.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/19.
//

/* 图片浏览器封装1
 Usage:
 
 import SwiftUI
 import Kingfisher

 struct ImageViewer: View {
     
     let images: [String] // 图片名字存储在数组中
     
     @State private var scale: CGFloat = 1.0
     
     @State private var isShowImageBrowser: Bool = false
     
     @State private var selectedIndex: Int = 0
     
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
                             isShowImageBrowser = true
                             selectedIndex = index
                         }
                 }
                 // 使用
                 ImageBrowser(isPresented: $isShowImageBrowser, images: ImageSource.urls(images), index: selectedIndex)
             }
         }
         
     }
 }
 
 */

import SwiftUI
import SKPhotoBrowser

struct ImageBrowser: View {
    @Binding var isPresented: Bool
    var images: ImageSource
    var index: Int = 0

    var body: some View {
        Group {
            if isPresented {
                SKPhotoBrowserRepresentable(isPresented: $isPresented, photos: convertToSKPhotos(images: images), initialIndex: index)
            }
        }
    }
    
    private func convertToSKPhotos(images: ImageSource) -> [SKPhoto] {
        switch images {
        case .uiImages(let uiImages):
            return uiImages.map(SKPhoto.photoWithImage)
        case .urls(let urls):
            return urls.map(SKPhoto.photoWithImageURL)
        }
    }
}

//
//  ImageBrowser.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/19.
//

import SwiftUI
import SKPhotoBrowser

/* 图片浏览器封装2
 Usage:
 
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
 
 */

class ImageBrowserManager {
    
    static let shared = ImageBrowserManager()
    
    private init() {}
    
    func showPhotoBrowser(images: ImageSource, at index: Int) {
        
        switch images {
        case .uiImages(let images):
            let skPhotos = convertImagesToSKPhotos(images: images)
            showSKPhotoBrowser(photos: skPhotos, initialIndex: index)
        case .urls(let images):
            let skPhotos = convertImageUrlsToSKPhotos(images: images)
            showSKPhotoBrowser(photos: skPhotos, initialIndex: index)
        }
    }
    
    private func convertImagesToSKPhotos(images: [UIImage]) -> [SKPhoto] {
        return images.map { SKPhoto.photoWithImage($0) } // 考虑缓存的可能性
    }
    
    private func convertImageUrlsToSKPhotos(images: [String]) -> [SKPhoto] {
        return images.map { SKPhoto.photoWithImageURL($0) } // 考虑缓存的可能性
    }
    
    private func showSKPhotoBrowser(photos: [SKPhoto], initialIndex: Int = 0) {
        if let viewController = UIApplication.shared.getCurrentViewController() {
            PhotoBrowserManager.shared.showPhotos(from: viewController, photos: photos, initialIndex: initialIndex)
        }
    }
    
}

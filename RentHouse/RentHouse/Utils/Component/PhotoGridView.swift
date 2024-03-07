//
//  PhotoGridView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/5.
//

/*
 图片浏览器
 */

import Foundation
import SwiftUI
import PhotosUI
import SKPhotoBrowser


struct ImageBrowserView: View {
    @Binding var images: [UIImage]
    @State private var showingImagePicker = false
    private let maxImageCount = 9
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    @State private var isShowingImageViewer = false
    @State private var selectedImage: UIImage?
    @State private var selectedImageIndex: Int = 0
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(images.indices, id: \.self) { index in
                    ZStack(alignment: .topTrailing) {
                        imageItem(for: images[index])
                            .onTapGesture { handleImageTap(at: index) }
                        deleteButton(for: index)
                            .padding(.trailing, 0) // 调整按钮在右上角的位置
                            .padding(.top, 0)
                    }
                }
                addButtonIfNeeded()
            }
            .padding()
            .sheet(isPresented: $showingImagePicker) {
                // 第三方库
                ImagePickerCoordinatorView(selectedImages: $images, maxSelection: maxImageCount - images.count)
            }
            .frame(width: 350)
            
        }
    }
    
    
    
    
    @ViewBuilder
    private func deleteButton(for index: Int) -> some View {
        Button(action: {
            withAnimation {
                removeImage(at: index)
            }
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(.black).opacity(0.6)
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 0))
        }
    }
    
    
    
    @ViewBuilder
    private func imageItem(for image: UIImage) -> some View {
        ImageItem(image: image)
    }
    
    @ViewBuilder
    private func addButtonIfNeeded() -> some View {
        if images.count < maxImageCount {
            Button(action: { showingImagePicker = true }) {
                Image(systemName: "plus").imageScale(.large)
                    .foregroundColor(.black)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .background(.gray).opacity(0.08)
                    .cornerRadius(9) // 回复注释，确保一致性
            }
            .interactiveDismissDisabled()
        }
    }
    
    private func handleImageTap(at index: Int) {
        selectedImageIndex = index
        selectedImage = images[index]
        withAnimation { isShowingImageViewer = true }
        let skPhotos = convertImagesToSKPhotos(images: images)
        showSKPhotoBrowser(photos: skPhotos, initialIndex: index)
    }
    
    // 其余的 ImageBrowserView 实现...
    private func convertImagesToSKPhotos(images: [UIImage]) -> [SKPhoto] {
        return images.map { SKPhoto.photoWithImage($0) } // 考虑缓存的可能性
    }
    
    private func removeImage(at index: Int) {
        images.remove(at: index)
    }
}


struct ImageItem: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .clipped()
            .cornerRadius(8)
    }
}





//// 封装的图片浏览器组件
//struct ImageBrowserView: View {
//    @Binding var images: [UIImage]// = [] // 存储选择的图片
//    @State private var showingImagePicker = false // 是否显示图片选择器
//    private let maxImageCount = 9 // 最多显示的图片数量
//    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3) // 每行显示3个项目
//    @State private var isShowingImageViewer = false // 是否显示大图浏览视图
//    @State private var selectedImage: UIImage? // 被选中查看的图片
//    @State private var selectedImageIndex: Int = 0 // 被选中查看的图片索引
//
//    var body: some View {
//        ScrollView {
//            LazyVGrid(columns: columns, spacing: 10) {
//                ForEach(images.indices, id: \.self) { index in
//                    Image(uiImage: images[index])
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 100, height: 100)
//                        .clipped()
//                        .cornerRadius(8)
//                        .onTapGesture(count: 1) {
//                            selectedImageIndex = index
//                            print("Selected image index: \(index), \(selectedImageIndex)") // 调试输出
//                            selectedImage = images[index]
//                            withAnimation {
//                                isShowingImageViewer = true
//                            }
//                            
//                            let skPhotos = convertImagesToSKPhotos(images: images)
//                            self.showSKPhotoBrowser(photos: skPhotos, initialIndex: index)
//                        }
//                        .simultaneousGesture(
//                            TapGesture(count: 2).onEnded {
//                                withAnimation {
//                                    removeImage(at: index)
//                                }
//                            }
//                        )
//                }
//                if images.count < maxImageCount {
//                    Button(action: {
//                        showingImagePicker = true
//                    }) {
//                        Image(systemName: "plus")
//                            .frame(width: 100, height: 100)
//                            .foregroundColor(.gray)
//                            .border(Color.gray, width: 1)
////                            .cornerRadius(8)
//                    }
//                }
//            }
//            .padding()
//            .sheet(isPresented: $showingImagePicker) {
//                ImagePickerCoordinatorView(selectedImages: $images) // 第三方库
//            }
//        }
//    }
//    
//    private func removeImage(at index: Int) {
//        images.remove(at: index)
//    }
//    
//    // 其余的 ImageBrowserView 实现...
//    private func convertImagesToSKPhotos(images: [UIImage]) -> [SKPhoto] {
//        return images.map { SKPhoto.photoWithImage($0) }
//    }
//}

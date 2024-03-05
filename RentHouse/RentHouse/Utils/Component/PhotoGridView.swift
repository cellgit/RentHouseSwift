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

// 封装的图片浏览器组件
struct ImageBrowserView: View {
    @Binding var images: [UIImage]// = [] // 存储选择的图片
    @State private var showingImagePicker = false // 是否显示图片选择器
    private let maxImageCount = 9 // 最多显示的图片数量
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3) // 每行显示3个项目
    @State private var isShowingImageViewer = false // 是否显示大图浏览视图
    @State private var selectedImage: UIImage? // 被选中查看的图片
    @State private var selectedImageIndex: Int = 0 // 被选中查看的图片索引

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(images.indices, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(8)
                        .onTapGesture(count: 1) {
                            selectedImageIndex = index
                            print("Selected image index: \(index), \(selectedImageIndex)") // 调试输出
                            selectedImage = images[index]
                            withAnimation {
                                isShowingImageViewer = true
                            }
                            
                            let skPhotos = convertImagesToSKPhotos(images: images)
                            self.showSKPhotoBrowser(photos: skPhotos, initialIndex: index)
                        }
                        .simultaneousGesture(
                            TapGesture(count: 2).onEnded {
                                withAnimation {
                                    removeImage(at: index)
                                }
                            }
                        )
                }
                if images.count < maxImageCount {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Image(systemName: "plus")
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .border(Color.gray, width: 1)
//                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .sheet(isPresented: $showingImagePicker) {
//                PhotoPicker(selectedImages: $images, maxSelection: maxImageCount - images.count)
                PhotoPicker(selectedImages: images, maxSelection: maxImageCount - images.count) { images in
                    self.images = images
                }
            }
        }
    }
    
    private func removeImage(at index: Int) {
        images.remove(at: index)
//        onImagesUpdated(images)  //通知父视图更新
    }
    
    // 其余的 ImageBrowserView 实现...
    private func convertImagesToSKPhotos(images: [UIImage]) -> [SKPhoto] {
        return images.map { SKPhoto.photoWithImage($0) }
    }
}



//struct PhotoView: View {
//    var image: UIImage
//    @State private var scale: CGFloat = 1.0
//    @State private var offset: CGSize = .zero
//
//    var body: some View {
//        GeometryReader { geometry in
//            Image(uiImage: image)
//                .resizable()
//                .scaledToFit()
//                .scaleEffect(scale)
//                .offset(offset)
//                .gesture(MagnificationGesture()
//                            .onChanged { value in
//                                scale = value.magnitude
//                            }
//                )
//                .gesture(DragGesture()
//                            .onChanged { value in
//                                offset = value.translation
//                            }
//                            .onEnded { _ in
//                                withAnimation {
//                                    offset = .zero
//                                }
//                            }
//                )
//        }
//    }
//}
//
//struct ImageViewer: View {
//    var images: [UIImage]
//    @Binding var isShowing: Bool
//    @State private var selectedImageIndex = 0
//
//    var body: some View {
//        TabView(selection: $selectedImageIndex) {
//            ForEach(images.indices, id: \.self) { index in
//                PhotoView(image: images[index])
//            }
//        }
//        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
//        .onTapGesture {
//            withAnimation {
//                isShowing = false
//            }
//        }
//    }
//}

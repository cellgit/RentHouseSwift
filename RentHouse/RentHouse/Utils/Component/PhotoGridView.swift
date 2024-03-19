//
//  PhotoGridView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/5.
//

/*
 图片浏览器
 */

import SwiftUI
import SKPhotoBrowser


struct ImageBrowserView: View {
    @Binding var images: [UIImage]
    @State private var showingImagePicker = false
    private let maxImageCount = 9
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(images.indices, id: \.self) { index in
                    ZStack(alignment: .topTrailing) {
                        imageItem(for: images[index])
                            .onTapGesture { handleImageTap(at: index) }
                        deleteButton(for: index)
                            .padding(.trailing, 0)
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
                    .foregroundColor(Color(.placeholderText))
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .background(Color.bg_unselected)
                    .cornerRadius(9)
            }
            .interactiveDismissDisabled()
        }
    }
    
    private func handleImageTap(at index: Int) {
        ImageBrowserManager.shared.showPhotoBrowser(images: .uiImages(images), at: index)
    }
    
    private func convertImagesToSKPhotos(images: [UIImage]) -> [SKPhoto] {
        return images.map { SKPhoto.photoWithImage($0) }
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

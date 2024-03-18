////
////  ImagePickerRepresentable.swift
////  RentHouse
////
////  Created by liuhongli on 2024/3/6.
////
//
//import Foundation
//import SwiftUI
//import BSImagePicker
//import Photos
//
//
//struct ImagePicker: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> BSImagePicker.ImagePickerController {
//        
//    }
//    
//    @Binding var selectedAssets: [PHAsset]
//    var maxSelections: Int
//    
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let imagePicker = ImagePickerController()
//        imagePicker.settings.selection.max = maxSelections
//        imagePicker.settings.theme.selectionStyle = .numbered
//        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image] // 只选择图片
//        // 自定义按钮和文本
//        imagePicker.settings.theme.selectionFillColor = UIColor.blue
//        imagePicker.settings.theme.selectionStrokeColor = UIColor.yellow
//        imagePicker.settings.theme.selectionShadowColor = UIColor.red
//        imagePicker.settings.theme.selectionTextColor = UIColor.white
//        imagePicker.settings.theme.selectionCharacter = nil // 使用数字而非字符
//        // 更多自定义设置...
//        
//        imagePicker.modalPresentationStyle = .fullScreen
//        return imagePicker
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        // 更新UI控制器（如果需要）
//    }
//    
//    typealias UIViewControllerType = ImagePickerController
//    
//    class Coordinator: NSObject, ImagePickerControllerDelegate {
//        func imagePicker(_ imagePicker: BSImagePicker.ImagePickerController, didReachSelectionLimit count: Int) {
//            //
//        }
//        
//        var parent: ImagePicker
//        
//        init(parent: ImagePicker) {
//            self.parent = parent
//        }
//        
//        func imagePicker(_ imagePicker: ImagePickerController, didSelectAsset asset: PHAsset) {
//            parent.selectedAssets.append(asset)
//        }
//        
//        func imagePicker(_ imagePicker: ImagePickerController, didDeselectAsset asset: PHAsset) {
//            if let index = parent.selectedAssets.firstIndex(of: asset) {
//                parent.selectedAssets.remove(at: index)
//            }
//        }
//        
//        func imagePicker(_ imagePicker: ImagePickerController, didFinishWithAssets assets: [PHAsset]) {
//            parent.selectedAssets = assets
//            imagePicker.dismiss(animated: true)
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//}
//


import SwiftUI
import Photos
import BSImagePicker


public struct ImagePickerCoordinatorView {
    
    @Binding var selectedImages: [UIImage]
    
    // 最多可选择数量
    var maxSelection: Int
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
}

extension ImagePickerCoordinatorView: UIViewControllerRepresentable {

    public typealias UIViewControllerType = ImagePickerController
    
    public func makeUIViewController(context: Context) -> ImagePickerController {
        let picker = ImagePickerController()
        
        picker.settings.selection.max = maxSelection
        picker.settings.selection.unselectOnReachingMax = false
        picker.settings.theme.selectionStyle = .numbered
        picker.settings.fetch.assets.supportedMediaTypes = [.image]
        picker.doneButtonTitle = "完成"
        picker.cancelButton = UIBarButtonItem(title: "取消", style: .done, target: nil, action: nil)
        picker.imagePickerDelegate = context.coordinator
        
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: ImagePickerController, context: Context) {
        
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

extension ImagePickerCoordinatorView {
    public class Coordinator: ImagePickerControllerDelegate {
        private let parent: ImagePickerCoordinatorView
        
        public init(_ parent: ImagePickerCoordinatorView) {
            self.parent = parent
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didSelectAsset asset: PHAsset) {
            print("Selected: \(asset)")
            
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didDeselectAsset asset: PHAsset) {
            print("Deselected: \(asset)")
        }
        
//        public func imagePicker(_ imagePicker: ImagePickerController, didFinishWithAssets assets: [PHAsset]) {
//            print("Finished with selections: \(assets)")
//            
//            let imageManager = PHImageManager.default()
//            let imageOptions = PHImageRequestOptions()
//            imageOptions.isSynchronous = true
//            
//            let videoOptions = PHVideoRequestOptions()
//            videoOptions.deliveryMode = .automatic
//            
//            for asset in assets {
//                if asset.mediaType == .image {
//                    imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: imageOptions) { image, _ in
//                        if let image = image {
//                            self.parent.selectedImages.append(image)
//                        }
//                    }
//                } else if asset.mediaType == .video {
//                    imageManager.requestAVAsset(forVideo: asset, options: videoOptions) { (avAsset, audioMix, info) in
//                        // 处理视频文件
//                        // 例如，你可以获取视频的URL并将其保存或使用
//                        if let urlAsset = avAsset as? AVURLAsset {
//                            let videoURL = urlAsset.url
//                            print("Video URL: \(videoURL)")
//                            // 如果需要，你可以在这里执行进一步的操作，例如将视频URL传递给UI层
//                            self.parent.selectedVideos.append(videoURL)
//                        }
//                    }
//                }
//            }
//            
//            // 关闭图片选择器
//            imagePicker.dismiss(animated: true)
//        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didFinishWithAssets assets: [PHAsset]) {
            print("Finished with selections: \(assets)")
            
            
            let imageManager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            for asset in assets {
                imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { image, _ in
                    if let image = image {
                        self.parent.selectedImages.append(image)
                    }
                }
            }
            // 关闭图片选择器
            // 通知要关闭图片选择器
            imagePicker.dismiss(animated: true)
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didCancelWithAssets assets: [PHAsset]) {
            print("Canceled with selections: \(assets)")
            imagePicker.dismiss(animated: true)
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didReachSelectionLimit count: Int) {
            print("Did Reach Selection Limit: \(count)")
        }
    }
}

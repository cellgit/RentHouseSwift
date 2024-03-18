//
//  VideoPickerRepresentable.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/17.
//

import SwiftUI
import Photos
import BSImagePicker


public struct VideoPickerCoordinatorView {
    
    @Binding var selectedVideos: [URL]
    
    // 最多可选择数量
    var maxSelection: Int
    
    /// 只支持 video
    var mediaType: PHAssetMediaType = .video
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
}

extension VideoPickerCoordinatorView: UIViewControllerRepresentable {

    public typealias UIViewControllerType = ImagePickerController
    
    public func makeUIViewController(context: Context) -> ImagePickerController {
        let picker = ImagePickerController()
        
        picker.settings.selection.max = maxSelection
        picker.settings.selection.unselectOnReachingMax = false
        picker.settings.theme.selectionStyle = .numbered
        picker.settings.fetch.assets.supportedMediaTypes = [.video]
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

extension VideoPickerCoordinatorView {
    public class Coordinator: ImagePickerControllerDelegate {
        private let parent: VideoPickerCoordinatorView
        
        public init(_ parent: VideoPickerCoordinatorView) {
            self.parent = parent
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didSelectAsset asset: PHAsset) {
            print("Selected: \(asset)")
            
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didDeselectAsset asset: PHAsset) {
            print("Deselected: \(asset)")
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didFinishWithAssets assets: [PHAsset]) {
            print("Finished with selections: \(assets)")
            
            let imageManager = PHImageManager.default()
            let imageOptions = PHImageRequestOptions()
            imageOptions.isSynchronous = true
            
            let videoOptions = PHVideoRequestOptions()
            videoOptions.deliveryMode = .automatic
            
            for asset in assets {
                imageManager.requestAVAsset(forVideo: asset, options: videoOptions) { (avAsset, audioMix, info) in
                    // 处理视频文件
                    // 获取视频的URL(不保存)
                    if let urlAsset = avAsset as? AVURLAsset {
                        let videoURL = urlAsset.url
                        print("Video URL: \(videoURL)")
                        // 如果需要，你可以在这里执行进一步的操作，例如将视频URL传递给UI层
                        self.parent.selectedVideos.append(videoURL)
                    }
                }
            }
            
            // 关闭图片选择器
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

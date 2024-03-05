//
//  SwiftUIPHPicker.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/5.
//

/*
 图片选择器
 */

import Foundation
import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    var selectedImages: [UIImage]
    var maxSelection: Int
    var onImagesUpdated: ([UIImage]) -> Void // 图片更新回调
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = maxSelection
        configuration.filter = .images // 仅显示图片
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            if results.isEmpty {
                picker.dismiss(animated: true)
                return
            }
            
            let group = DispatchGroup()
            var images: [UIImage] = self.parent.selectedImages
            
            for result in results {
                guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else { continue }
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    defer { group.leave() }
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            images.append(image)
                        }
                    }
                }
            }
            
            group.notify(queue: .main) {
                if results.count > images.count {
                    let diffCount = (results.count - images.count)
                    debugPrint("您有\(diffCount)张格式不支持的图片被过滤掉,请检查图片格式")
                }
                //                self.parent.selectedImages = images
                self.parent.onImagesUpdated(images)
                picker.dismiss(animated: true)
            }
        }
    }
}

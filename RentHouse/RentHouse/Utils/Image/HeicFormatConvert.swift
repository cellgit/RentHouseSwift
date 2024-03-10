//
//  HeicFormatConvert.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/10.
//

import Foundation
import UIKit
import ImageIO
import MobileCoreServices
import AVFoundation



extension UIImage {
    
    func toHEIF(compressionQuality: CGFloat) -> Data? {
        guard let imageData = self.jpegData(compressionQuality: 1.0) else { return nil }
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        let options: [String: Any] = [
            kCGImageDestinationLossyCompressionQuality as String: compressionQuality,
            kCGImageDestinationBackgroundColor as String: UIColor.clear
        ]

        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data, AVFileType.heic as CFString, 1, nil) else { return nil }
        CGImageDestinationAddImageFromSource(destination, source, 0, options as CFDictionary)
        
        guard CGImageDestinationFinalize(destination) else { return nil }
        return data as Data
    }
    
    func toHEIFThenJPEG(compressionQualityForHEIF: CGFloat, compressionQualityForJPEG: CGFloat) -> Data? {
        // 首先，将UIImage转换为HEIF格式的Data
        guard let heifData = self.toHEIF(compressionQuality: compressionQualityForHEIF) else { return nil }
        
        // 接下来，将HEIF Data转换回UIImage
        guard let heifImage = UIImage(data: heifData) else { return nil }
        
        // 最后，将UIImage转换为JPEG格式的Data
        return heifImage.jpegData(compressionQuality: compressionQualityForJPEG)
    }
    
}



//
//  UIImage+extension.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/2.
//

import Foundation
import UIKit

extension UIImage {
    
    
    /// 压缩图片
    /// - Parameter CGFloat: 0.8
    /// - Returns: 压缩后的图片
    func compress(to compressionQuality: CGFloat = 0.5) -> Data? {
        return self.jpegData(compressionQuality: compressionQuality)
    }
    
    
    // 压缩jpg图片
    func compressToLessThan200KB() -> Data? {
        let maxFileSize = 200 * 1024 // 200 KB
        var compressionQuality: CGFloat = 1.0
        var compressedData: Data? = self.jpegData(compressionQuality: compressionQuality)
        if compressedData?.count ?? 0 > maxFileSize * 200 {
            compressedData = self.jpegData(compressionQuality: 0.005)
        }
        else if compressedData?.count ?? 0 > maxFileSize * 100 {
            compressedData = self.jpegData(compressionQuality: 0.01)
        }
        else if compressedData?.count ?? 0 > maxFileSize * 10 {
            compressedData = self.jpegData(compressionQuality: 0.1)
        }
        else {
            while (compressedData?.count ?? 0) > maxFileSize && compressionQuality > 0 {
                compressionQuality -= 0.1 // 每次降低5%
                compressedData = self.jpegData(compressionQuality: compressionQuality)
            }
        }
        return compressedData
    }

    
    func optimizedPNG() -> Data? {
        guard let cgImage = self.cgImage else { return nil }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = cgImage.bitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext(data: nil, width: cgImage.width, height: cgImage.height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        
        guard let newCgImage = context?.makeImage() else { return nil }
        let optimizedImage = UIImage(cgImage: newCgImage)
        debugPrint("Optimized Image Size: \(String(describing: optimizedImage.pngData()?.count))")
        
        return optimizedImage.pngData()
    }
}

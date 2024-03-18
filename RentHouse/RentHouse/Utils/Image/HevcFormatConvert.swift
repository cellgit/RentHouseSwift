//
//  HevcFormatConvert.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/17.
//


// Usage example:
// Assuming you have defined inputURL, outputHEVCURL, and finalOutputURL
// async {
//     let result = await convertAndCompressVideo(inputURL: inputURL, outputHEVCURL: outputHEVCURL, finalOutputURL: finalOutputURL, resolution: .res1080p)
//     switch result {
//     case .success(let url):
//         print("Video processed successfully: \(url)")
//     case .failure(let error):
//         print("Error processing video: \(error.localizedDescription)")
//     }
// }


import Foundation
import AVFoundation
import UIKit
import AVFoundation

/*
@available(iOS 4.0, *)
public let AVAssetExportPresetLowQuality: String
@available(iOS 4.0, *)
public let AVAssetExportPresetMediumQuality: String
@available(iOS 4.0, *)
public let AVAssetExportPresetHighestQuality: String

/* These export options can be used to produce movie files with video size appropriate to the device.
   The export will not scale the video up from a smaller size. The video will be compressed using
   HEVC and the audio will be compressed using AAC.  */
@available(iOS 11.0, *)
public let AVAssetExportPresetHEVCHighestQuality: String
@available(iOS 13.0, *)
public let AVAssetExportPresetHEVCHighestQualityWithAlpha: String

/* These export options can be used to produce movie files with the specified video size.
   The export will not scale the video up from a smaller size. The video will be compressed using
   H.264 and the audio will be compressed using AAC.  Some devices cannot support some sizes. */
@available(iOS 4.0, *)
public let AVAssetExportPreset640x480: String
@available(iOS 4.0, *)
public let AVAssetExportPreset960x540: String
@available(iOS 4.0, *)
public let AVAssetExportPreset1280x720: String
@available(iOS 5.0, *)
public let AVAssetExportPreset1920x1080: String
@available(iOS 9.0, *)
public let AVAssetExportPreset3840x2160: String

/* These export options can be used to produce movie files with the specified video size.
   The export will not scale the video up from a smaller size. The video will be compressed using
   HEVC and the audio will be compressed using AAC.  Some devices cannot support some sizes. */
@available(iOS 11.0, *)
public let AVAssetExportPresetHEVC1920x1080: String
@available(iOS 13.0, *)
public let AVAssetExportPresetHEVC1920x1080WithAlpha: String
@available(iOS 11.0, *)
public let AVAssetExportPresetHEVC3840x2160: String
@available(iOS 13.0, *)
public let AVAssetExportPresetHEVC3840x2160WithAlpha: String

@available(iOS 17.0, *)
public let AVAssetExportPresetMVHEVC960x960: String
@available(iOS 17.0, *)
public let AVAssetExportPresetMVHEVC1440x1440: String

/*  This export option will produce an audio-only .m4a file with appropriate iTunes gapless playback data */
@available(iOS 4.0, *)
public let AVAssetExportPresetAppleM4A: String

/* This export option will cause the media of all tracks to be passed through to the output exactly as stored in the source asset, except for
   tracks for which passthrough is not possible, usually because of constraints of the container format as indicated by the specified outputFileType.
   This option is not included in the arrays returned by -allExportPresets and -exportPresetsCompatibleWithAsset. */
@available(iOS 4.0, *)
public let AVAssetExportPresetPassthrough: String

/* This export option will produce a QuickTime movie with Apple ProRes 422 video and LPCM audio. */
@available(iOS 15.0, *)
public let AVAssetExportPresetAppleProRes422LPCM: String

/* This export option will produce a QuickTime movie with Apple ProRes 4444 video and LPCM audio. */
@available(iOS 15.0, *)
public let AVAssetExportPresetAppleProRes4444LPCM: String
 
 */


enum VideoExportPreset {
    case none   // 不进行压缩
    case hevcHighestQuality // 使用HEVC编码的最高质量
    case hevcHighestQualityWithAlpha // 使用HEVC编码的最高质量，并支持Alpha通道
    case lowQuality // 低质量
    case mediumQuality // 中等质量
    case highestQuality // 最高质量
    case size640x480 // 分辨率640x480，使用H.264和AAC编码
    case size960x540 // 分辨率960x540，使用H.264和AAC编码
    case size1280x720 // 分辨率1280x720，使用H.264和AAC编码
    case size1920x1080 // 分辨率1920x1080，使用H.264和AAC编码
    case size3840x2160 // 分辨率3840x2160，使用H.264和AAC编码
    case hevc1920x1080 // 使用HEVC编码的分辨率1920x1080
    case hevc1920x1080WithAlpha // 使用HEVC编码的分辨率1920x1080，并支持Alpha通道
    case hevc3840x2160 // 使用HEVC编码的分辨率3840x2160
    case hevc3840x2160WithAlpha // 使用HEVC编码的分辨率3840x2160，并支持Alpha通道
    case mvhevc960x960 // 使用多视图HEVC编码的分辨率960x960
    case mvhevc1440x1440 // 使用多视图HEVC编码的分辨率1440x1440
    case appleM4A // 仅音频，生成符合iTunes无缝播放数据的.m4a文件
    case passthrough // 媒体数据透传，不进行转码，除非源格式不支持透传
    case appleProRes422LPCM // 使用Apple ProRes 422视频和LPCM音频的QuickTime电影
    case appleProRes4444LPCM // 使用Apple ProRes 4444视频和LPCM音频的QuickTime电影
    case custom(presetName: String) // 允许用户指定自定义的压缩预设

    var presetName: String? {
        switch self {
        case .none:
            return nil
        case .hevcHighestQuality:
            return AVAssetExportPresetHEVCHighestQuality
        case .hevcHighestQualityWithAlpha:
            return AVAssetExportPresetHEVCHighestQualityWithAlpha
        case .lowQuality:
            return AVAssetExportPresetLowQuality
        case .mediumQuality:
            return AVAssetExportPresetMediumQuality
        case .highestQuality:
            return AVAssetExportPresetHighestQuality
        case .size640x480:
            return AVAssetExportPreset640x480
        case .size960x540:
            return AVAssetExportPreset960x540
        case .size1280x720:
            return AVAssetExportPreset1280x720
        case .size1920x1080:
            return AVAssetExportPreset1920x1080
        case .size3840x2160:
            return AVAssetExportPreset3840x2160
        case .hevc1920x1080:
            return AVAssetExportPresetHEVC1920x1080
        case .hevc1920x1080WithAlpha:
            return AVAssetExportPresetHEVC1920x1080WithAlpha
        case .hevc3840x2160:
            return AVAssetExportPresetHEVC3840x2160
        case .hevc3840x2160WithAlpha:
            return AVAssetExportPresetHEVC3840x2160WithAlpha
        case .mvhevc960x960:
            return AVAssetExportPresetMVHEVC960x960
        case .mvhevc1440x1440:
            return AVAssetExportPresetMVHEVC1440x1440
        case .appleM4A:
            return AVAssetExportPresetAppleM4A
        case .passthrough:
            return AVAssetExportPresetPassthrough
        case .appleProRes422LPCM:
            return AVAssetExportPresetAppleProRes422LPCM
        case .appleProRes4444LPCM:
            return AVAssetExportPresetAppleProRes4444LPCM
        case .custom(presetName: let presetName):
            return presetName
        }
    }
}

extension URL {
    func convertAndCompressVideo(inputURL: URL, outputHEVCURL: URL, exportPreset: VideoExportPreset = .none) async -> Result<URL, Error> {
        // 如果compressionQuality为.none，直接转换为HEVC，不进行压缩
        guard let presetName = exportPreset.presetName else {
            return await convertVideoToHEVC(inputURL: inputURL, outputURL: outputHEVCURL, presetName: AVAssetExportPresetHEVCHighestQuality)
        }
        
        // 使用指定的压缩预设进行转换和压缩
        return await convertVideoToHEVC(inputURL: inputURL, outputURL: outputHEVCURL, presetName: presetName)
    }

    func convertVideoToHEVC(inputURL: URL, outputURL: URL, presetName: String) async -> Result<URL, Error> {
        let asset = AVAsset(url: inputURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: presetName) else {
            return .failure(NSError(domain: "ExportSessionCreationFailed", code: -1, userInfo: ["description": "Unable to create export session with the specified preset. The preset may not be supported on this device, or HEVC may not be supported."]))
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true

        return await withCheckedContinuation { continuation in
            exportSession.exportAsynchronously {
                switch exportSession.status {
                case .completed:
                    continuation.resume(returning: .success(outputURL))
                case .failed:
                    continuation.resume(returning: .failure(exportSession.error ?? NSError(domain: "ExportFailed", code: -1, userInfo: nil)))
                default:
                    continuation.resume(returning: .failure(NSError(domain: "ExportNotCompleted", code: -1, userInfo: nil)))
                }
            }
        }
    }
}




//extension URL {
//    func convertAndCompressVideo(inputURL: URL, outputHEVCURL: URL) async -> Result<URL, Error> {
//        // Convert to HEVC without adjusting the resolution
//        let conversionResult = await convertVideoToHEVC(inputURL: inputURL, outputURL: outputHEVCURL)
//        return conversionResult
//    }
//
//    /// Converts a video to HEVC format asynchronously without adjusting its resolution.
//    func convertVideoToHEVC(inputURL: URL, outputURL: URL) async -> Result<URL, Error> {
//        let asset = AVAsset(url: inputURL)
//        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHEVCHighestQuality) else {
//            return .failure(NSError(domain: "ExportSessionCreationFailed", code: -1, userInfo: ["description": "Unable to create export session. HEVC may not be supported on this device."]))
//        }
//
//        exportSession.outputURL = outputURL
//        exportSession.outputFileType = .mp4 // Ensure the output file type is set to .mp4
//        exportSession.shouldOptimizeForNetworkUse = true
//
//        // Use a continuation to bridge between async/await and callback-based API.
//        return await withCheckedContinuation { continuation in
//            exportSession.exportAsynchronously {
//                switch exportSession.status {
//                case .completed:
//                    continuation.resume(returning: .success(outputURL))
//                case .failed:
//                    continuation.resume(returning: .failure(exportSession.error ?? NSError(domain: "ExportFailed", code: -1, userInfo: nil)))
//                default:
//                    continuation.resume(returning: .failure(NSError(domain: "ExportNotCompleted", code: -1, userInfo: nil)))
//                }
//            }
//        }
//    }
//}





//enum VideoResolution {
//    case res720p
//    case res1080p
//    case res4K
//    
//    var size: CGSize {
//        switch self {
//        case .res720p:
//            return CGSize(width: 1280, height: 720)
//        case .res1080p:
//            return CGSize(width: 1920, height: 1080)
//        case .res4K:
//            return CGSize(width: 3840, height: 2160)
//        }
//    }
//}
//
//
//extension URL {
//    
//    func convertAndCompressVideo(inputURL: URL, outputHEVCURL: URL, finalOutputURL: URL, resolution: VideoResolution) async -> Result<URL, Error> {
//        // Step 1: Convert to HEVC
//        let conversionResult = await convertVideoToHEVC(inputURL: inputURL, outputURL: outputHEVCURL)
//        if case .failure(let error) = conversionResult {
//            return .failure(error)
//        }
//        
//        // Step 2: Compress/Adjust resolution
//        let compressionResult = await compressVideo(inputURL: outputHEVCURL, outputURL: finalOutputURL, resolution: resolution)
//        return compressionResult
//    }
//
//    func compressVideo(inputURL: URL, outputURL: URL, resolution: VideoResolution) async -> Result<URL, Error> {
//        let asset = AVAsset(url: inputURL)
//
//        // Ensure tracks are loaded
//    //    let tracks = await asset.loadTracks(withMediaType: .video)
//        
//        let tracks: [AVAssetTrack]
//        do {
//            tracks = try await asset.loadTracks(withMediaType: .video)
//        } catch {
//            return .failure(error)
//        }
//        
//        guard let videoTrack = tracks.first else {
//            return .failure(NSError(domain: "VideoTrackLoadFailed", code: 0, userInfo: nil))
//        }
//
//        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
//            return .failure(NSError(domain: "ExportSessionCreationFailed", code: 0, userInfo: nil))
//        }
//
//        // Attempting to use 'await' for 'load' operation (following a conceptual approach as 'load' is hypothetical here)
//        let videoSize: CGSize
//        do {
//            videoSize = try await videoTrack.load(.naturalSize)
//        } catch {
//            return .failure(error)
//        }
//
//        let aspectRatio = videoSize.width / videoSize.height
//        let outputSize = resolution.size
//        let adjustedSize: CGSize
//        if outputSize.width / outputSize.height > aspectRatio {
//            adjustedSize = CGSize(width: outputSize.height * aspectRatio, height: outputSize.height)
//        } else {
//            adjustedSize = CGSize(width: outputSize.width, height: outputSize.width / aspectRatio)
//        }
//
//        let videoComposition = AVMutableVideoComposition(propertiesOf: asset)
//        videoComposition.renderSize = adjustedSize
//        videoComposition.frameDuration = CMTime(value: 1, timescale: 30) // Assuming 30fps video
//
//        exportSession.outputURL = outputURL
//        exportSession.outputFileType = .mp4
//        exportSession.shouldOptimizeForNetworkUse = true
//        exportSession.videoComposition = videoComposition
//
//        await exportSession.export()
//
//        switch exportSession.status {
//        case .completed:
//            return .success(outputURL)
//        case .failed:
//            return .failure(exportSession.error ?? NSError(domain: "ExportFailed", code: 0, userInfo: nil))
//        default:
//            return .failure(NSError(domain: "ExportNotCompleted", code: 0, userInfo: nil))
//        }
//    }
//
//    /// Converts a video to HEVC format asynchronously.
//    func convertVideoToHEVC(inputURL: URL, outputURL: URL) async -> Result<URL, Error> {
//        let asset = AVAsset(url: inputURL)
//        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHEVCHighestQuality) else {
//            return .failure(NSError(domain: "ExportSessionCreationFailed", code: -1, userInfo: ["description": "Unable to create export session. HEVC may not be supported on this device."]))
//        }
//        
//        exportSession.outputURL = outputURL
//        exportSession.outputFileType = .mp4
//        exportSession.shouldOptimizeForNetworkUse = true
//        
//        // Use a continuation to bridge between async/await and callback-based API.
//        return await withCheckedContinuation { continuation in
//            exportSession.exportAsynchronously {
//                switch exportSession.status {
//                case .completed:
//                    continuation.resume(returning: .success(outputURL))
//                case .failed:
//                    continuation.resume(returning: .failure(exportSession.error ?? NSError(domain: "ExportFailed", code: -1, userInfo: nil)))
//                default:
//                    continuation.resume(returning: .failure(NSError(domain: "ExportNotCompleted", code: -1, userInfo: nil)))
//                }
//            }
//        }
//    }
//    
//}

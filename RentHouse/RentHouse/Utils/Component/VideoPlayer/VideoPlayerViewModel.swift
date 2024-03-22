//
//  VideoPlayerViewModel.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/20.
//

import SwiftUI
import AVFoundation

//class VideoPlayerViewModel: ObservableObject {
//    private var playerItem: AVPlayerItem?
//    var player: AVPlayer?
//
//    init(videoURL: URL) {
//        
//        
//        self.playerItem = AVPlayerItem(url: videoURL)
//        self.player = AVPlayer(playerItem: self.playerItem)
//        // 设置预加载的秒数，例如预加载30秒的视频内容
//        self.playerItem?.preferredForwardBufferDuration = 30
//        debugPrint("videoURL ====== \(videoURL)")
//    }
//    
//    func play() {
//        self.player?.play()
//    }
//}



import AVFoundation
import Foundation

class VideoPlayerViewModel: ObservableObject {
    private var asset: AVURLAsset?
    private var playerItem: AVPlayerItem?
    @Published var player: AVPlayer?
    
    init(videoURL: URL) {
//        asset = AVURLAsset(url: URL(string: "http://tanhua2120.oss-cn-shanghai.aliyuncs.com/rental/videos/original/65dd9bddc331dac77ff0a197/20240318-31d12ed7-video.mp4")!)
        debugPrint("videoURL ==== \(videoURL)")
        Task {
            asset = AVURLAsset(url: videoURL)
            loadAssetProperties()
        }
    }
    
    // 使用async标记的函数来异步加载资源属性
    private func loadAssetProperties() {
        // 使用非阻塞方式加载asset的属性
        Task {
            guard let asset = self.asset else { return }
            self.playerItem = AVPlayerItem(asset: asset)
            self.playerItem?.preferredForwardBufferDuration = 30
            do {
                // 加载必要的资源属性
                let (duration, tracks) = try await asset.load(.duration, .tracks)
                await self.setupPlayer(with: asset)
            } catch {
                // 错误处理
                print("Error loading asset properties: \(error)")
            }
        }
    }
    
    // 在MainActor中执行所有UI更新和player的设置
    @MainActor
    private func setupPlayer(with asset: AVURLAsset) {
//        self.playerItem = AVPlayerItem(asset: asset)
//        self.playerItem?.preferredForwardBufferDuration = 30
        self.player = AVPlayer(playerItem: self.playerItem)
    }
    
    @MainActor
    func play() {
        Task {
            player?.play()
        }
    }
    
    
    @MainActor
    func pause() {
        Task {
            player?.pause()
        }
    }
    
    
//    @MainActor
//    func change() {
//        Task {
//            // Stop the player when the view disappears
//            await loadPlayerItem(newValue)
//            
//        }
//    }
    
    
    
    
    
//        .onDisappear() {
//            Task {
//                // Stop the player when the view disappears
//                player?.pause()
//                
//            }
//        }
//        .onChange(of: videoURL) { oldValue, newValue in
//            Task {
//                await loadPlayerItem(newValue)
//                
//            }
//        }
    
    
}



// 创建AVPlayerItem和AVPlayer，更新UI
//    @MainActor
//    private func updateUI() {
//        guard let asset = asset else { return }
//
//        self.playerItem = AVPlayerItem(asset: asset)
//        // 设置预加载的秒数，例如预加载30秒的视频内容
//        self.playerItem?.preferredForwardBufferDuration = 30
//        self.player = AVPlayer(playerItem: self.playerItem)
//    }

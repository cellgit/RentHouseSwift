//
//  VideoPlayerView2.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/20.
//

import SwiftUI
import AVKit

//struct VideoPlayerView2: UIViewRepresentable {
//    var player: AVPlayer
//
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView(frame: .zero)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = view.bounds
//        playerLayer.videoGravity = .resizeAspect // 保持视频宽高比
//        view.layer.addSublayer(playerLayer)
//        view.backgroundColor = .black
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {
//        if let layer = uiView.layer.sublayers?.first as? AVPlayerLayer {
//            layer.player = player
//            layer.frame = uiView.frame
//        }
//    }
//}


struct CustomVideoPlayer: UIViewControllerRepresentable {
    
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> some AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

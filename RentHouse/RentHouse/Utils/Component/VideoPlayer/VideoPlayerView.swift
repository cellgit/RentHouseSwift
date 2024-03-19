//
//  VideoPlayerView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/19.
//

import SwiftUI
import AVKit


struct VideoPlayerView: View {
    
    private let player: AVPlayer
    
    init(videoURL: URL) {
        self.player = AVPlayer(url: videoURL)
        
        
    }
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.play()
            }
    }
    
}

#Preview {
    VideoPlayerView(videoURL: URL(string: "http://tanhua2120.oss-cn-shanghai.aliyuncs.com/rental/videos/original/65dd9bddc331dac77ff0a197/20240318-43357c8e-video.mp4")!)
}

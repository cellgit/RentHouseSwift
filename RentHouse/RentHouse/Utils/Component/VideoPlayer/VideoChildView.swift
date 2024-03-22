//
//  VideoChildView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/22.
//

import SwiftUI
import AVKit

struct VideoChildView: View {
    @StateObject var playerViewModel: VideoPlayerViewModel
    
//    var ratio: CGFloat = 16/9
    
    
    var body: some View {
        // 使用playerViewModel的地方
        
        ZStack {
            if let player = playerViewModel.player {
                
                VideoPlayerView(player: player)
//                    .onAppear {
//                        
//                        player.play()
//                    }
                    .onAppear() {
                        Task {
//                            player = AVPlayer()
//                            await loadPlayerItem(self.videoURL)
//                            player?.isMuted = true
//                            self.isMuted = player?.isMuted ?? false
                            
                            player.play()
                            
                            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                                player.seek(to: .zero)
                                player.play()
                            }
                        }//: Task
                    }//: onAppear
                    .onDisappear() {
                        Task {
                            // Stop the player when the view disappears
                            player.pause()
                            
                        }
                    }
//                    .onChange(of: videoURL) { oldValue, newValue in
//                        Task {
//                            await loadPlayerItem(newValue)
//                            
//                        }
//                    }
                
                CustomVideoPlayer(player: player)
//                    .onAppear {
//                        player.play()
//                    }
            }
                
        }
        
    }
}




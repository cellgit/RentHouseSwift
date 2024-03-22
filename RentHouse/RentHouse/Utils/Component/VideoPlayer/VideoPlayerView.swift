//
//  VideoPlayerView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/19.
//


//播放器文档: https://developer.apple.com/documentation/avfoundation/media_assets/retrieving_media_metadata

// https://developer.apple.com/documentation/avfoundation/avasynchronouskeyvalueloading/3747326-load


/* stackoverflow: 解决线程阻塞
 https://stackoverflow.com/questions/77224167/avplayer-unexpected-behaviour-after-ios-and-tvos-update-to-17-0
 
 */


import SwiftUI
import AVKit


struct VideoPlayerView: View {
    
    @State private var player: AVPlayer
    
    private let ratio: CGFloat
    
    init(player: AVPlayer, ratio: CGFloat = 16/9) {
        self.player = player
        self.ratio = ratio
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VideoPlayer(player: player)
                    .frame(height: geometry.size.width / ratio)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

//#Preview {
//    VideoPlayerView(videoURL: URL(string: "http://tanhua2120.oss-cn-shanghai.aliyuncs.com/rental/videos/original/65dd9bddc331dac77ff0a197/20240318-43357c8e-video.mp4")!, ratio: 9/16)
//}



import SwiftUI
import AVKit

struct VideoPlayerView2: View {
    
    private var videoURL : URL
    
    @State private var player: AVPlayer?
    
    @State private var isMuted: Bool = true
    
    var showMuteButton: Bool
    
    init(url: URL, showMuteButton: Bool = true) {
        self.videoURL = url
        self.showMuteButton = showMuteButton
    }
    
    
    var body: some View {
        VideoPlayer(player: player)
        
            .onAppear() {
                Task {
                    player = AVPlayer()
                    await loadPlayerItem(self.videoURL)
                    
                    player?.isMuted = true
                    self.isMuted = player?.isMuted ?? false
                    
                    player?.play()
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { _ in
                        self.player?.seek(to: .zero)
                        self.player?.play()
                    }
                }//: Task
            }//: onAppear
            .onDisappear() {
                Task {
                    // Stop the player when the view disappears
                    player?.pause()
                    
                }
            }
            .onChange(of: videoURL) { oldValue, newValue in
                Task {
                    await loadPlayerItem(newValue)
                    
                }
            }
            .overlay(alignment: .topTrailing) {
                if showMuteButton {
                    Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(Circle())
                        .padding()
                        .onTapGesture {
                            player?.isMuted.toggle()
                            self.isMuted = player?.isMuted ?? false
                        }
                }
            }
            
    }
    
    
    func loadPlayerItem(_ videoURL: URL) async {
        
        let asset = AVAsset(url: videoURL)
        do {
            let (_, _, _) = try await asset.load(.tracks, .duration, .preferredTransform)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let item = AVPlayerItem(asset: asset)
        player?.replaceCurrentItem(with: item)
        
    }
}

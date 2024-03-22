//
//  VideoBrowserView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/17.
//

/*
 视频浏览器
 */
import SwiftUI
import AVKit

struct VideoBrowserView: View {
    @Binding var videoURLs: [URL]
    @State private var showingImagePicker = false
    private let maxCount = 9
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(videoURLs.indices, id: \.self) { index in
                    ZStack(alignment: .topTrailing) {
                        videoItem(for: videoURLs[index])
                            .onTapGesture {
                                handleVideoTap(url: videoURLs[index])
                            }
                        deleteButton(for: index)
                            .padding(.trailing, 0) // 调整按钮在右上角的位置
                            .padding(.top, 0)
                    }
                }
                addButtonIfNeeded()
            }
            .padding()
            .sheet(isPresented: $showingImagePicker) {
                // 第三方库
                VideoPickerCoordinatorView(selectedVideos: $videoURLs, maxSelection: maxCount - videoURLs.count)
            }
            .frame(width: 350)
            
        }
    }
    
    @ViewBuilder
    private func addButtonIfNeeded() -> some View {
        if videoURLs.count < maxCount {
            Button(action: { showingImagePicker = true }) {
                Image(systemName: "plus").imageScale(.large)
                    .foregroundColor(Color(.placeholderText))
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .background(Color.bg_unselected)//.opacity(0.08)
                    .cornerRadius(9) // 回复注释，确保一致性
            }
            .interactiveDismissDisabled()
        }
    }
    

    @ViewBuilder
    private func videoItem(for url: URL) -> some View {
        VideoThumbnailView(url: url)
    }
    
    @ViewBuilder
    private func deleteButton(for index: Int) -> some View {
        Button(action: {
            withAnimation {
                var videos = $videoURLs.wrappedValue
                videos.remove(at: index)
                $videoURLs.wrappedValue = videos
            }
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(.black).opacity(0.6)
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 0))
        }
    }

    private func handleVideoTap(url: URL) {
        // 使用URL直接播放视频
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        let viewController = UIApplication.shared.getCurrentViewController()
        viewController?.present(playerViewController, animated: false) {
            player.play()
        }
    }
}

struct VideoPlayerController: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        return playerViewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}


/// 获取视频第一帧的缩略图
struct VideoThumbnailView: View {
    let url: URL
    @State private var thumbnail: UIImage?

    var body: some View {
        Group {
            if let thumbnail = thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onAppear {
                        loadThumbnail(from: url)
                    }
            }
        }
        .frame(width: 100, height: 100)
        .clipped()
        .cornerRadius(8)
        .overlay(
            Image(systemName: "play.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .opacity(0.8)
        )
    }
    
    private func loadThumbnail(from url: URL) {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            thumbnail = UIImage(cgImage: img)
        } catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
        }
    }
}

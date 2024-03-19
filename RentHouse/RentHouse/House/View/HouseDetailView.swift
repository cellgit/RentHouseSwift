//
//  HouseDetailView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/18.
//

import SwiftUI

struct HouseDetailView: View {
    
    @EnvironmentObject var tabBarState: TabBarStateManager
    
    @ObservedObject var viewModel: HouseDetailViewModel
    
    let model: House
    
    
    @State private var showVideo: Bool = true // 控制显示视频还是图片
    
    
    init(model: House) {
        self.model = model
        viewModel = HouseDetailViewModel(model: model)
        
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                if let videoUrlStr = model.videos?.first?.originalVideo?.url, let videoUrl = URL(string: videoUrlStr), let images = model.images {
                    if showVideo {
                        VideoPlayerView(videoURL: videoUrl)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .transition(.opacity)
                    } else {
                        ImageViewer(images: viewModel.images)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .transition(.opacity)
                    }
                }
                else if let videoUrlStr = model.videos?.first?.originalVideo?.url, let videoUrl = URL(string: videoUrlStr) {
                    VideoPlayerView(videoURL: videoUrl)
                }
                else if let images = model.images {
                    ImageViewer(images: viewModel.images)
                }
                else {
                    EmptyView()
                }
                
//                Button(action: {
//                    self.showVideo.toggle()
//                }) {
//                    Text(showVideo ? "切换到图片" : "切换到视频")
//                }
            }
        }
        .toolbar {
            Button(action: {
                withAnimation {
                    self.showVideo.toggle()
                }
            }) {
                Text(showVideo ? "切换到图片" : "切换到视频")
            }
        }
        
        .onAppear {
            withAnimation {
                tabBarState.visible = .hidden
            }
        }
        
        
        
//        NavigationLink {
//            ProfileView()
//        } label: {
//            Text("Push")
//        }
    }
        
}

#Preview {
    HouseDetailView(model: House())
}

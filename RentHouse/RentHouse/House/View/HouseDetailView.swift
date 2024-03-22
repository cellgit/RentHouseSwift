//
//  HouseDetailView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/18.
//

import SwiftUI
import AVKit

struct HouseDetailView: View {
    
    let model: House
    
    let viewModel: HouseDetailViewModel
    
    @State private var showVideo: Bool = true // 控制显示视频还是图片
    
    @State private var selectedIndex: Int = 0
    
    private var mediaTypes: [MediaType] = []
    
    var selectedMediaType: Binding<MediaType> {
        Binding(
            get: { MediaType(rawValue: selectedIndex) ?? .video },
            set: { selectedIndex = $0.rawValue }
        )
    }
    
    
    @State private var showSheet: Bool = true
    
    let onDismiss: () -> Void
    
    @State private var isOpen: Bool = true
    
    @State private var minArea: Double = 60
    @State private var maxArea: Double = UIScreen.main.bounds.height - UIScreen.main.bounds.width * (9/16) - 88.0
    
    @State private var radius: Double = 16
    
    @State private var backgroundDisabled: Bool = true
    @State private var backgroundColor: Color = Color.black.opacity(0.16)
    
    @State private var contentCoverColor: Color = .primary
    @State private var contentBGColor: Color = .primary
    
    @State private var indicatorMin: Double = 4
    @State private var indicatorMax: Double = 34
    @State private var indicatorColor: Color = .primary
    @State private var indicatorBGColor: Color = .secondary
    
    private var constants: SheetConstants {
        SheetConstants(
            minArea: minArea,
            maxArea: maxArea,
            radius: radius,
            
            backgroundDisabled: backgroundDisabled,
            backgroundColor: backgroundColor,
            
            contentCoverColor: contentCoverColor,
            contentBGColor: contentBGColor,
            
            indicatorMin: indicatorMin,
            indicatorMax: indicatorMax,
            indicatorColor: indicatorColor,
            indicatorBGColor: indicatorBGColor
        )
    }
    
    
     
    init(model: House, onDismiss: @escaping () -> Void) {
        self.model = model
        self.onDismiss = onDismiss
        viewModel = HouseDetailViewModel(model: model)
        
        if let videoUrlStr = viewModel.videos.first, let _ = URL(string: videoUrlStr) {
            mediaTypes.append(.video)
        }
        
        if let imageUrlStr = viewModel.images.first, let _ = URL(string: imageUrlStr) {
            mediaTypes.append(.image)
        }
        
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                TabView(selection: $selectedIndex) {
                    
                    if let videoUrlStr = viewModel.videos.first, let videoUrl = URL(string: videoUrlStr) {
                        ScrollView(.vertical, showsIndicators: true) {
                            let playerViewModel = VideoPlayerViewModel(videoURL: videoUrl)
                            
                            
                            VideoPlayerView2(url: videoUrl)
                                .frame(width: geometry.size.width, height: geometry.size.width / viewModel.videoRatio)
                            
//                            VideoChildView(playerViewModel: playerViewModel)
//                                .frame(width: geometry.size.width, height: geometry.size.width / viewModel.videoRatio)
                        }
                        .tag(0) // 为这个视图设置一个tag作为索引
                    }
                    
                    if let imageUrlStr = viewModel.images.first, let _ = URL(string: imageUrlStr) {
                        ScrollView(.horizontal, showsIndicators: true) {
                            ImageViewer(images: viewModel.images)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .transition(.opacity)
                                
                        }
                        .tag(1) // 为这个视图设置一个tag作为索引
                        .ignoresSafeArea()
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .menuIndicator(.hidden)
                .ignoresSafeArea()
                .onChange(of: selectedIndex) {// newIndex in // 监听selectedIndex的变化
                    print("Selected Index: \($0) \($1)")
                    // 在这里添加你希望在索引变化时执行的代码
                }
                
                GeometryReader { geometry in
                    
                        BottomSheet(isOpen: $isOpen, constants: constants) {
                            
                            ZStack (alignment: .top) {
//                                HomeView()
                                HouseDetailChildView(viewModel: viewModel)
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - UIScreen.main.bounds.width * (9/16) - 88.0 - minArea, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                Button {
                                    onDismiss()
                                } label: {
                                    Image(systemName: "x.circle.fill")
                                        .font(.title) // 可以根据需要调整图标大小
                                        .foregroundColor(.primary) // 可以根据需要调整图标颜色
                                }
                                .padding(.leading, (geometry.size.width-80))
                                .padding([.top], -50)
                                
                                MediaSwitchView(selectedMediaType: selectedMediaType, showTypes: mediaTypes) { type in
                                    withAnimation {
                                        selectedIndex = type.rawValue
                                    }
                                }
                                .frame(width: 200, height: 30, alignment: .center)
                                .padding([.top], -100)
                            }
                        }
                                            
                }
                
            }
        }
        
    }
    
}

//#Preview {
//    HouseDetailView(viewModel: HouseDetailViewModel(model: House()))
//}



//            .sheet(isPresented: $showSheet, onDismiss: {
//                showSheet = false
//            }, content: {
//                HomeView()
//                    .presentationDetents([
//                        .fraction(0.1),
//                        .height(300),
//                            .medium,
//                            .large,
//                    ])
//            })

//            .sheet(isPresented: $showSheet) {
//                HomeView()
//                    .presentationDetents([.height(100), .medium, .large])
//            }

//
//  HouseDetailTopView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/22.
//

import SwiftUI


enum MediaType: Int, CaseIterable, Identifiable {
    case video = 0
    case image = 1
    
    var id: Self { self } // Identifiable
    
    var title: String {
        switch self {
        case .video: return "视频"
        case .image: return "图片"
        }
    }
}

struct MediaSwitchView: View {
    @Binding var selectedMediaType: MediaType// = .video
    var showTypes: [MediaType] = MediaType.allCases
    
    var onSelectionChange: (MediaType) -> Void
    
    var body: some View {
        VStack {
            Picker("Select Media Type", selection: $selectedMediaType) {
                ForEach(showTypes, id: \.self) { type in
                    Text(type.title).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selectedMediaType) { newValue in
                onSelectionChange(newValue) // 当选择改变时调用回调
            }
        }
    }
}



//enum MediaType: Int8 {
//    case video = 0
//    case image = 1
//}
//
//
//struct MediaSwitchView: View {
//    @State var selectedMediaType: MediaType //= .video
//    
//    @State var showTypes: [MediaType]
//    
//    var onSelectionChange: (MediaType) -> Void  // 定义一个回调闭包
//    
//    var body: some View {
//        VStack {
//            Picker("Select Media Type", selection: $selectedMediaType) {
//                Text("Video").tag(MediaType.video)
//                Text("Image").tag(MediaType.image)
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
//            .onChange(of: selectedMediaType) { newMediaType in
//                onSelectionChange(newMediaType) // 当选择改变时调用回调
//            }
//        }
//    }
//}


#Preview {
    MediaSwitchView(selectedMediaType: .constant(.video), showTypes: [.video, .image]) { type in
        debugPrint("type ====== \(type)")
    }
}

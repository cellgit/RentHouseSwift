//
//  HouseDetailViewModel.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/19.
//

import Foundation
import Combine
//import SwiftUI

class HouseDetailViewModel: ObservableObject {
    private let model: House
    
    @Published var images: [String] = []
    
    @Published var videos: [String] = []
    
    init(model: House) {
        self.model = model
        
        parseImages()
        
        parseImages()
        
    }
    
    /// 获取图片的url数组
    func parseImages() {
        var list: [String] = []
        if let images = model.images {
            for image in images {
                if let url = image.original?.url {
                    list.append(url)
                }
            }
        }
        images = list
    }
    
    /// 获取视频的url数组
    func parseVideos() {
        var list: [String] = []
        if let videos = model.videos {
            for video in videos {
                if let url = video.originalVideo?.url {
                    list.append(url)
                }
            }
        }
        videos = list
    }
    
    
}

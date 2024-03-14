//
//  ProgressHandler.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/13.
//

import Foundation
import SwiftUI

class ProgressHandler: ObservableObject {
    @Published var isVisible: Bool = false
    @Published var progress: CGFloat = 0
    /// 上传状态
    @Published var uploadStatus: UploadProgressStatus = .none // 默认状态
}

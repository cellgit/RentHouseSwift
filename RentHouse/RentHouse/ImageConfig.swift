//
//  ImageConfig.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/7.
//

import Foundation
/*
 参考文档:
 https://help.aliyun.com/zh/oss/user-guide/resize-images-4?spm=a2c4g.11186623.0.0.5def74e9RxFlFA
 */
/// 按最短边缩放

let thumb_300 = "?x-oss-process=image/resize,s_300"

let thumb_400 = "?x-oss-process=image/resize,s_400"

let thumb_500 = "?x-oss-process=image/resize,s_500"

//let thumb_600 = "?x-oss-process=image/resize,s_600"

let thumb_900 = "?x-oss-process=image/resize,s_900"

//let thumb_heic_600 = "?x-oss-process=image/resize,l_923,h_600/format,heic"

let thumb_heic_600 = "?x-oss-process=image/resize,h_900/format,heic"


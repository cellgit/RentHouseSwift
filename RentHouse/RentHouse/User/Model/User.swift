//
//  User.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/28.
//

import Foundation

// 定义验证码响应的数据结构
struct User: Decodable {
    var msg: String?
    var token: String?
    var isNewUser: Bool?
    var phone: String?
}

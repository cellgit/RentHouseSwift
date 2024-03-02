//
//  String+extension.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/2.
//

import Foundation

extension String {
    /// 解码包含Unicode编码字符的JSON字符串
    var decodedUnicode: String {
        // 将当前字符串转换成Data
        guard let data = self.data(using: .utf8) else { return self }
        
        // 使用JSONSerialization尝试解析Data
        guard let decodedString = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? String else {
            return self
        }
        
        return decodedString
    }
}

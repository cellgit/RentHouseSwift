//
//  UserDefaultsKey.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/3.
//

import Foundation

enum UserDefaultsKey {
    case user
    case selectedCity
    
    var key: String {
        switch self {
        case .user: return "user"
        case .selectedCity: return "selectedCity"
        }
    }
    
    
}

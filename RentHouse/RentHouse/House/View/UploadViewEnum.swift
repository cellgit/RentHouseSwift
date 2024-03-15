//
//  UploadViewEnum.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/15.
//

import Foundation

// "可租", "已租", "预租", "已下架"

/*
可租: Available
已租: Rented Out
预出租: Pre-rent
下架: Unlisted
*/
enum HouseStatus: String {
    case rentAvailable = "可租"
    case rentedOut = "已租"
    case prerent = "预租"
    case unlisted = "下架"
    func value() -> Int {
        switch self {
        case .rentAvailable:
            return 1
        case .rentedOut:
            return 2
        case .prerent:
            return 3
        case .unlisted:
            return 4
        }
    }
}


/// 房型
enum RoomType: String {
    case one = "一室"
    case two = "两室"
    case three = "三室"
    case fourAndMore = "四室及以上"
    case none = ""
    
    func value() -> String {
        switch self {
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .fourAndMore:
            return "4"
        case .none:
            return ""
        }
    }
}


/// 朝向
///
/// orientation

/// 房间朝向
enum RoomOrientation: String {
    case south = "东"
    case north = "南"
    case east = "西"
    case west = "北"
    case southEast = "东南"
    case northEast = "东北"
    case southWest = "西南"
    case northWest = "西北"
    case none = ""
    
    func value() -> String {
        switch self {
        case .south:
            return "1"
        case .north:
            return "2"
        case .east:
            return "3"
        case .west:
            return "4"
        case .southEast:
            return "5"
        case .northEast:
            return "6"
        case .southWest:
            return "7"
        case .northWest:
            return "8"
        case .none:
            return ""
        }
    }
}


/// decoration装修情况

/*
 "简装", "精装", "豪华装修", "毛坯"
 精装修: Fully-furnished / High-quality Decoration
 简装: Simply-furnished / Basic Decoration
 豪华装修: Luxuriously Decorated
 毛坯房: Unfurnished / Bare Shell
 */
enum HouseDecoration: String {
    /// 简装
    case basic = "简装"
    /// 精装
    case highQuality = "精装"
    /// 豪华装修
    case luxuriously = "豪华装修"
    /// 毛坯
    case unfurnished = "毛坯"
    
    
    func value() -> String {
        switch self {
        case .basic:
            return "1"
        case .highQuality:
            return "2"
        case .luxuriously:
            return "3"
        case .unfurnished:
            return "4"
        }
    }
    
}


/*
月付: Monthly Payment
季付: Quarterly Payment
半年付: Semi-annual Payment
年付: Annual Payment
*/

enum PaymentMethod: String {
    case monthly = "月付"
    case quarterly = "季付"
    case semiAnnual = "半年付"
    case annual = "年付"
    
    func value() -> String {
        switch self {
        case .monthly:
            return "1"
        case .quarterly:
            return "2"
        case .semiAnnual:
            return "3"
        case .annual:
            return "4"
        }
    }
    
}

/// 付款方式转换
struct PaymentMethodStruct {
    
    func getPaymentMethods(_ items: Set<String>) -> [String] {
        var valueList: [String] = []
        items.forEach { item in
            if let value = PaymentMethod(rawValue: item)?.value() {
                valueList.append(value)
            }
        }
        return valueList
    }
}


//struct FacilitiesStruct {
//    
//    func getPaymentMethods(_ items: Set<String>) -> [String] {
//        var valueList: [String] = []
//        items.forEach { item in
//            if let value = PaymentMethod(rawValue: item)?.value() {
//                valueList.append(value)
//            }
//        }
//        return valueList
//    }
//    
//}


//facilities

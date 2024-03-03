//
//  UserDefaultsManager.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/3.
//

import Foundation
//enum UserDefaultsKey {
//    case user
//    case bookDetail
//
//    var key: String {
//        switch self {
//        case .user: return "UserInfo"
//        case .bookDetail: return "BookDetail"
//        }
//    }
//
//
//}


import Foundation

public struct UserDefaultsManager {

    // 存入数据: 数据需遵守Codable协议
    // 示例:
    // let model = UserModel(json) // UserModel需遵守Codable协议
    // UserDefaultsManager.save(model, forKey: UserDefaultsKey.user.key)
    public static func save<T: Codable>(_ data: T, forKey key: String) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encodedData, forKey: key)
        } catch {
            print("Save error: \(error)")
        }
    }

    // 获取数据
    // 示例:
    // let user: UserModel? = UserDefaultsManager.get(forKey: UserDefaultsKey.user.key)
    public static func get<T: Codable>(forKey key: String, ofType type: T.Type) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Get error: \(error)")
            return nil
        }
    }

    // 删除数据
    // 示例: UserDefaultsManager.delete(forKey: UserDefaultsKey.user.key)
    public static func delete(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }

    // 增加的删除方法，带有成功和失败的回调是不必要的，因为UserDefaults的删除操作是即时的，
    // 并且如果键不存在，它也不会导致错误。因此，我们可以保持简单的删除方法。
    // 如果你需要根据删除的结果执行不同的逻辑，建议在调用删除方法后直接在代码中处理这些逻辑。
}





//public struct UserDefaultsManager {
//
//    /*
//     存入数据: 数据为 Any 类型
//     示例:
//     let model = UserModel(json)
//     UserDefaultsManager.save(model, UserDefaultsKey.user.key)
//     */
//    public static func save(_ data: Any, _ key: String) {
//        var userInfoData: Data?
//        do {
//            if #available(iOS 11.0, *) {
//                userInfoData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
//            } else {
//                userInfoData = NSKeyedArchiver.archivedData(withRootObject: data)
//            }
//
//        } catch {
//            debugPrint("archivedData Error")
//        }
//        UserDefaults.standard.setValue(userInfoData, forKey: key)
//    }
//
//    /*
//     获取数据
//     示例:
//     UserDefaultsManager.get(UserDefaultsKey.user.key, UserModel.self)
//     */
//    public static func get<T>(_ key: String, _ classType: T.Type) -> T? {
//        if let data = UserDefaults.standard.data(forKey: key) {
//            if let user = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T {
//                return user
//            }
//        }
//        return nil
//    }
//
//    /// 删除: UserDefaultsManager.delete(UserDefaultsKey.user.key)
//    public static func delete(_ key: String) {
//        UserDefaults.standard.removeObject(forKey: key)
//    }
//
//    public static func delete(_ key: String, success: () -> (), failure: () -> () = {}) {
//        UserDefaults.standard.removeObject(forKey: key)
//        
//        success()
//        
//        //failure()
//        
////        if User.current()?.token == nil {
////            success()
////        } else {
////            failure()
////        }
//    }
//
//}

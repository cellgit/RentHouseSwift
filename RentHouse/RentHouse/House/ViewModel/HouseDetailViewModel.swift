//
//  HouseDetailViewModel.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/19.
//

import Foundation
import Combine
import MapKit
import SwiftUI
//import SwiftUI

class HouseDetailViewModel: ObservableObject {
    private let model: House
    
    @Published var images: [String] = []
    
    @Published var videos: [String] = []
    
    @Published var videoRatio: CGFloat = 9/16
    
    /// 社区+楼栋+单元
    @Published var address: String = ""
    
//    /// 区/县
//    @Published var district: String = ""
//    /// 社区
//    @Published var community: String = ""
//    /// 楼栋(为空不显示)
//    @Published var building: String = ""
//    /// 单元
//    @Published var unit: String = ""
    
    /// 房号
    @Published var houseNumber: String = ""
    
    /// 房间号
    @Published var roomNumber: String = ""
    /// 状态
    @Published var status: String = ""
    
    /// 付款方式
    @Published var paymentMethod: [String] = []
    
    /// roomType
    
    /// 价格
    @Published var price: String = ""
    /// 租赁方式 (rentalMethod)：1整租、2合租
    @Published var rentalMethod: String = ""
    /// 房型 (roomType)：例如一室一厅、两室一厅等
    @Published var roomType: String = ""
    /// 面积
    @Published var area: String = ""
    
    /// 所在楼层/总楼层
    @Published var floor: String = ""
    // 装修情况 (decoration)：1精装修、2简装修、3豪华装修、4毛坯房、5自定义内容
    @Published var decoration: String = ""
    
    @Published var facilities: [String] = []
    
    @Published var desc: String = ""
    
    @Published var contact: String = ""
    
    @Published var orientation: String = ""
    
    @Published var tags: [String] = []
    
    @Published var leaseTerm: String = ""
    
    @Published var availableDate: String = ""
    
    @Published var petPolicy: String = ""
    
    @Published var moveInRequirements: String = ""
    
    @Published var additionalFees: [String] = []
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.0522, longitude: 120.2437), // 这里是杭州的坐标，仅作默认
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
//    @Published var region: MapCameraPosition = MapCameraPosition(
//        center: CLLocationCoordinate2D(latitude: 40.0522, longitude: 120.2437), // 这里是杭州的坐标，仅作默认
//        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    @Published var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.0522, longitude: 120.2437), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
    
    @Published var coordinate = CLLocationCoordinate2D(latitude: 40.0522, longitude: 120.2437)
    
    
    
    
    
//    // 临时定义一个地图区域，实际应用中你可能需要根据实际情况动态设置
//        @State private var region = MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437), // 这里是洛杉矶的坐标，仅作示例
//            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        )
    
    
//    let review = Review(user: "123", rating: 5, comment: "评价说:好房源不要错过哦")
//    let house = House(price: 2500, rentalMethod: 1, community: "多蓝水岸蓝波苑", building: "4", city: "杭州", district: "钱塘区", citycode: "0571", unit: "1", houseNumber: "301", roomNumber: "A", status: 1, paymentMethod: ["1"], center: Center(lat: 40.0, lon: 120.1), location: nil, roomType: "1", area: 25, floor: 3, totalFloors: 6, decoration: 1, facilities: ["冰箱", "洗衣机", "热水器"], desc: "来吧,租房是你的选择", landlordId: nil, contact: "18298269522", orientation: "1", reviewStatus: "1", tags: ["近地铁", "好房源", "好房东"], leaseTerm: "一年", rating: 5, availableDate: "2024-08", petPolicy: true, moveInRequirements: "一家人", publishDate: "2024-03", reviews: [review], additionalFees: [], createdAt: "2024-03-22", updatedAt: "2024-03-22", id: "123")
    
    
    
    init(model: House) {
        self.model = model
        
        parseImages()
        
        parseVideos()
        
        parseData()
        
    }
    
    /// 获取图片的url数组
    func parseImages() {
        var list: [String] = []
        if let images = model.images {
            for image in images {
                if let url = image.medium?.url {
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
                if let originalVideo = video.originalVideo, let width = originalVideo.width, let height = originalVideo.height {
                    videoRatio = width / height
                }
            }
        }
        videos = list
    }
    
    
    func parseData() {
        price = "\(model.price ?? 0)"
        
        address = "\(model.community ?? "")\(model.building ?? "")号楼\(model.unit ?? "")单元"
        
        houseNumber = "\(model.houseNumber ?? "")"
        
        roomNumber = "\(model.roomNumber ?? "")"
        
        status = statusText(model.status)
        
        // 付款方式 (paymentMethod)：1月付、2季付、3半年付、4年付
        if let list = model.paymentMethod {
            paymentMethod.removeAll()
            paymentMethod = list.compactMap(paymentMethodText)
        }
        /// 租赁方式
        rentalMethod = rentalMethodText(model.rentalMethod)
        
        roomType = roomTypeText(model.roomType)
        
        if let roomArea = model.area {
            area = "\(roomArea)平米"
        }
        
        floor = floorText()
        
        
        
        decoration = decorationText(model.decoration)
        
        if let list = model.facilities {
            facilities = list.compactMap(facilitiesText)
        }
        if let list = model.tags {
            tags = list.compactMap(tagsText)
        }
        
        desc = model.desc ?? ""
        
        contact = model.contact ?? ""
        
        
        orientation = orientationText(model.orientation)
        
        leaseTerm = model.leaseTerm ?? ""
        
        availableDate = availableDateText(model.availableDate)
        
        petPolicy = petPolicyText(model.petPolicy)
        
        moveInRequirements = moveInRequirementsText(model.moveInRequirements)
        
        if let list = model.additionalFees {
            additionalFees = list.compactMap(additionalFeesText)
        }
        
        region = regionData(lat: model.center?.lat, lon: model.center?.lon)
        
        position = positionData(lat: model.center?.lat, lon: model.center?.lon)
        
        coordinate = coordinateData(lat: model.center?.lat, lon: model.center?.lon)
        
    }
    
    func regionData(lat: Double?, lon: Double?) -> MKCoordinateRegion {
        
        guard let lat = lat, let lon = lon else { return region }
        
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: lon), // 这里是洛杉矶的坐标，仅作示例
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }
    
    func positionData(lat: Double?, lon: Double?) -> MapCameraPosition {
        
        guard let lat = lat, let lon = lon else { return position }
        
        return MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
    }
    
    func coordinateData(lat: Double?, lon: Double?) -> CLLocationCoordinate2D {
        guard let lat = lat, let lon = lon else { return coordinate }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    
    func statusText(_ value: Int?) -> String {
        // 房源状态 1: 出租中, 2: 已出租, 3: 预出租, 4:已下架
        guard let value = value else { return ""}
        switch value {
        case 1:
            return "可租"
        case 2:
            return "已租"
        case 3:
            return "预租"
        case 4:
            return "下架"
        default:
            return ""
        }
    }
    
    
    func paymentMethodText(_ value: String) -> String? {
        switch value {
        case "1":
            return "月付"
        case "2":
            return "季付"
        case "3":
            return "半年付"
        case "4":
            return "年付"
        default:
            return nil
        }
    }
    
    
    func roomTypeText(_ value: String?) -> String {
        switch value {
        case "1":
            return "一室"
        case "2":
            return "两室"
        case "3":
            return "三室"
        case "4":
            return "四室及以上"
        default:
            return ""
        }
    }
    
    func rentalMethodText(_ value: Int?) -> String {
        switch value {
        case 1:
            return "整租"
        case 2:
            return "合租"
        default:
            return ""
        }
    }
    
    
    func floorText() -> String {
        if let floorValue = model.floor, let totalFloorvalue = model.totalFloors {
            return "\(floorValue)/\(totalFloorvalue)"
        }
        else if let floorValue = model.floor {
            return "\(floorValue)"
        }
        else {
            return ""
        }
    }
    
    func decorationText(_ value: Int?) -> String {
        // 装修情况 (decoration)：1精装修、2简装修、3豪华装修、4毛坯房
        switch value {
        case 1:
            return "精装"
        case 2:
            return "简装"
        case 3:
            return "豪华装修"
        case 4:
            return "毛坯"
        default:
            return ""
        }
    }
    
    
    
    func facilitiesText(_ value: String?) -> String? {
        return value
    }
    
    func tagsText(_ value: String?) -> String? {
        return value
    }
    
    func additionalFeesText(_ value: String?) -> String? {
        return value
    }
    
    
    // 朝向 (orientation)：房源的朝向，1东, 2南, 3西, 4北, 5东南, 6东北, 7西南, 8西北
    func orientationText(_ value: String?) -> String {
        switch value {
        case "1":
            return "南"
        case "2":
            return "东"
        case "3":
            return "西"
        case "4":
            return "北"
        case "5":
            return "东南"
        case "6":
            return "东北"
        case "7":
            return "西南"
        case "8":
            return "西北"
        default:
            return ""
        }
    }
    
    func availableDateText(_ value: String?) -> String {
        guard let value = value else {
            return ""
        }
        return value
    }
    
    func petPolicyText(_ value: Bool?) -> String {
        if value == false {
            return "否"
        }
        else {
            return "是"
        }
    }
    
    func moveInRequirementsText(_ value: String?) -> String {
        guard let value = value else {
            return ""
        }
        return value
    }
    
    func additionalFeesText(_ value: AdditionalFee?) -> String {
        guard let value = value, let name = value.name, let amount = value.amount else {
            return ""
        }
        return "\(name):\(amount)"
    }
    
    
    
    
    
}




//    func parseVideos() {
//        var list: [String] = []
//        if let videos = model.videos {
//            for video in videos {
//                if let url = video.originalVideo?.url {
//                    list.append(url)
//                }
//            }
//        }
//        videos = list
//    }

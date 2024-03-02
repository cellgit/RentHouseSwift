//
//  HouseServiceProtocol.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/1.
//

import Combine
import UIKit

protocol HouseServiceProtocol {
    
    func uploadHouse(
        // 房源图片
        images: [UIImage],
        // 价格
        price: Double,
        // 租赁方式: 1整租、2合租
        rentalMethod: Int,
        // 坐标经度
        lon: Double,
        // 坐标纬度
        lat: Double,
        // 省份名
        province: String,
        // 城市名
        city: String,
        // 区/县名
        district: String,
        // 城市编码
        citycode: String,
        // 小区
        community: String,
        // 建筑编号
        building: String,
        // 单元号
        unit: String,
        // 房号
        houseNumber: String,
        // 房间号
        roomNumber: String,
        // 联系方式
        contact: String,
        // 租赁状态: 1出租中, 2已出租, 3已下架, 4预出租
        status: Int,
        // 房型
        roomType: String,
        // 房子所在楼层
        floor: Int,
        // 建筑物总楼层
        totalFloors: Int,
        // 房间面积
        area: Double,
        // 朝向
        orientation: String,
        // 可租日期
        availableDate: String,
        // 租期
        leaseTerm: String,
        // 付款方式：1押一付一、2押一付三、3押一付六、4押一付十二
        paymentMethod: String,
        // 装修情况 (decoration)：1精装修、2简装修、3豪华装修、4毛坯
        decoration: String,
        // 描述
        desc: String,
        // 设备配置
        facilities: [String],
        // 房源标签
        tags: [String],
        // 是否可养宠物
        petPolicy: Bool,
        // 房东硬性要求
        moveInRequirements: String,
        // // 附加费用
        additionalFees: [String]
    ) -> AnyPublisher<[House], Never>
    
}

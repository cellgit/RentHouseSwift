//
//  UploadStateManager.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/7.
//

import Foundation
import Combine
import Drops
import UIKit

extension UploadStateManager {
    
    func upload(
        // 房源图片
        images: [UIImage],
        // 视频URL(从相册取出的视频URL)
        videos: [URL],
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
        paymentMethod: [String],
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
        additionalFees: [String]) {
            Task {
                await prepareAndStartUpload(images: images,
                                            videos: videos,
                                            price: price,
                                            rentalMethod: rentalMethod,
                                            lon: lon,
                                            lat: lat,
                                            province: province,
                                            city: city,
                                            district: district,
                                            citycode: citycode,
                                            community: community,
                                            building: building,
                                            unit: unit,
                                            houseNumber: houseNumber,
                                            roomNumber: roomNumber,
                                            contact: contact,
                                            status: status,
                                            roomType: roomType,
                                            floor: floor,
                                            totalFloors: totalFloors,
                                            area: area,
                                            orientation: orientation,
                                            availableDate: availableDate, //availableDate
                                            leaseTerm: leaseTerm,
                                            paymentMethod: paymentMethod,
                                            //                                          paymentMethod: paymentMethod,
                                            decoration: decoration,
                                            desc: desc,
                                            facilities: facilities,
                                            tags: tags,
                                            petPolicy: petPolicy,
                                            moveInRequirements: moveInRequirements,
                                            additionalFees: additionalFees)
            }
            
    }
    
    
    func prepareAndStartUpload(
        // 房源图片
        images: [UIImage],
        // 视频URL(从相册取出的视频URL)
        videos: [URL],
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
        paymentMethod: [String],
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
    ) async {
        
        await MainActor.run {
            self.isUploading = true
        }
        
        // 首先异步获取处理后的视频URLs
        let videoURLs = await getVideoUrls(videos: videos)
        
        let router = HouseApi.uploadHouse(images: images,
                                          videos: videoURLs,
                                          price: price,
                                          rentalMethod: rentalMethod,
                                          lon: lon,
                                          lat: lat,
                                          province: province,
                                          city: city,
                                          district: district,
                                          citycode: citycode,
                                          community: community,
                                          building: building,
                                          unit: unit,
                                          houseNumber: houseNumber,
                                          roomNumber: roomNumber,
                                          contact: contact,
                                          status: status,
                                          roomType: roomType,
                                          floor: floor,
                                          totalFloors: totalFloors,
                                          area: area,
                                          orientation: orientation,
                                          availableDate: availableDate, //availableDate
                                          leaseTerm: leaseTerm,
                                          paymentMethod: paymentMethod,
                                          //                                          paymentMethod: paymentMethod,
                                          decoration: decoration,
                                          desc: desc,
                                          facilities: facilities,
                                          tags: tags,
                                          petPolicy: petPolicy,
                                          moveInRequirements: moveInRequirements,
                                          additionalFees: additionalFees)
        
        
        
        
        // 因为startUpload中包含UI更新的操作，所以我们确保它在主线程中调用
        await MainActor.run {
            self.startUpload(router: router)
        }
        
//        DispatchQueue.main.async { [weak self] in
//            guard let `self` = self else { return }
//            // 在获取到视频URLs后启动上传过程
//            self.startUpload(router: router)
//        }
        
    }
    
}

class UploadStateManager: ObservableObject {
    @Published var isUploading: Bool = false
    @Published var uploadProgress: Double = 0.0 // 0.0 to 1.0
    @Published var uploadSuccess: Bool? = nil // nil表示未完成，true表示成功，false表示失败
    @Published var uploadMessage: String = ""
    @Published var uploadError: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    var progressHandler: ProgressHandler
    
    init(progressHandler: ProgressHandler) {
        self.progressHandler = progressHandler
    }
    
    
    func startUpload(router: ApiRouter) {
        uploadSuccess = nil
        cancellables.removeAll()
        isUploading = true
        
        // 上传时, 0则是在处理资源中..., 大于0小于1上传中,等于1上传完成,失败后设置为0.1
        self.uploadProgress(isUploading, progress: 0, status: .preparing)
        
        
//        // 在这个方法中，任何修改@Published属性的操作也需要确保在主线线程中执行
//        Task {
//            await MainActor.run {
//                // 所有的UI更新操作...
//            }
//        }
        
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shared.uploadWithProgress(router)
                .sink(receiveCompletion: { completion in
                    // 处理完成或失败
                    DispatchQueue.main.async {
                        switch completion {
                        case .finished:
                            break // 如果需要，这里可以处理完成后的逻辑
                        case .failure(let error):
                            self.uploadError = error
                            self.isUploading = false
                            self.uploadSuccess = false
                        }
                    }
                }, receiveValue: { [weak self] (uploadResult: UploadResult<House>) in
                    guard let self = self else { return }

                    DispatchQueue.main.async {
                        switch uploadResult {
                        case .progress(let uploadProgress):
                            // 处理上传进度
                            self.uploadProgress = uploadProgress.progress
                            //uploadProgress.progress >= 1
                            self.uploadProgress(self.isUploading, progress: uploadProgress.progress, status: .uploading)
                            
                            // 其他进度更新逻辑
                        case .completion(let result):
                            // 处理完成后的响应数据
                            switch result {
                            case .success(let responseData):
                                // 成功逻辑处理
                                self.uploadSuccess = true
                                self.isUploading = false
                                self.uploadAlert(true)
                                self.uploadProgress(self.isUploading, progress: 1, status: .success)
                            case .failure(let error):
                                // 失败逻辑处理
                                self.uploadError = error
                                self.isUploading = false
                                self.uploadSuccess = false
                                self.uploadAlert(false)
                                self.uploadProgress(self.isUploading, progress: 0.1, status: .failure)
                            }
                        }
                    }
                })
                .store(in: &self.cancellables)
        }

        
    }
    
    func uploadProgress(_ isVisiable: Bool, progress: CGFloat = 0, status: UploadProgressStatus) {
        switch status {
        case .preparing, .uploading:
            progressHandler.isVisible = isVisiable
        case .success, .failure:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.progressHandler.isVisible = isVisiable
            }
        case .none:
            progressHandler.isVisible = false
        }
        progressHandler.progress = progress // 或者根据实际情况更新进度
        progressHandler.uploadStatus = status
    }
    
    
    func uploadAlert(_ isSuccess: Bool) {
        if isSuccess {
            let drop = Drop(
                title: "上传成功",
                icon: UIImage.init(named: "checkmark.circle.pulse.byLayer"),
                action: .init {
                    print("Drop tapped")
                    Drops.hideCurrent()
                },
                position: .top,
                duration: 5.0,
                accessibility: "Alert: 上传成功, Subtitle"
            )
            Drops.show(drop)
        }
        else {
            let drop = Drop(
                title: "上传失败,请重试",
                icon: UIImage.init(named: "xmark.circle"),
                action: .init {
                    print("Drop tapped")
                    Drops.hideCurrent()
                },
                position: .top,
                duration: 5.0,
                accessibility: "Alert: 上传成功, Subtitle"
            )
            Drops.show(drop)
        }
        
    }
    
    
    func getVideoUrls(videos: [URL]) async -> [URL] {
        // 创建一个任务组（Task Group）来处理视频
        let urls = await withTaskGroup(of: URL?.self, body: { group in
            // 对每个视频URL发起一个任务
            for video in videos {
                group.addTask {
                    let id = Date().timeIntervalSince1970
                    let outputHEVCURL = temporaryFileURL(fileName: "\(id)tempHEVCVideo.mp4")
                    
                    // 尝试视频转换和压缩
                    let result = await video.convertAndCompressVideo(inputURL: video, outputHEVCURL: outputHEVCURL, exportPreset: .hevc1920x1080)

                    // 无论成功还是失败，完成后都删除临时文件
//                    defer {
//                        deleteFile(at: outputHEVCURL)
//                    }

                    // 根据结果返回URL或nil
                    switch result {
                    case .success(let url):
                        print("Video processed successfully: \(url)")
                        return url
                    case .failure(let error):
                        print("Error processing video: \(error.localizedDescription)")
                        return nil
                    }
                }
            }

            // 收集所有成功的结果
            var urls: [URL] = []
            for await result in group {
                if let url = result {
                    urls.append(url)
                }
            }
            return urls
        })

        return urls
    }

    
}



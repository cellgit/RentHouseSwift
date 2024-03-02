//
//  HouseUploadView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/28.
//

import Foundation
import SwiftUI
import Combine

struct UploadView: View {
    @StateObject var viewModel = HouseUploadViewModel()
    @State private var uploadResult: Bool?
    @State private var cancellables = Set<AnyCancellable>()
    
    //    @State private var images: [UIImage] = []
    @State private var images: [UIImage] = [UIImage.init(named: "009")!]
    @State private var price: Double = 2600
    @State private var rentalMethod: Int = 1
    @State private var lon: Double = 116.306121
    @State private var lat: Double = 40.052978
    @State private var province: String = "浙江省"
    @State private var city: String = "杭州市"
    @State private var district: String = "钱塘区"
    @State private var citycode: String = "0571"
    @State private var community: String = "多蓝水岸-"
    @State private var building: String = "17号楼"
    @State private var unit: String = "3"
    @State private var houseNumber: String = "501"
    @State private var roomNumber: String = "A"
    @State private var contact: String = "18298269622"
    @State private var status: Int = 1
    @State private var roomType: String = "1"
    @State private var floor: Int = 5
    @State private var totalFloors: Int = 17
    @State private var area: Double = 25
    @State private var orientation: String = "1"
    @State private var availableDate: String = "2024-03-22"
    @State private var leaseTerm: String = "1年"
    @State private var paymentMethod: String = ""
    @State private var decoration: String = ""
    @State private var desc: String = ""
    @State private var facilities: [String] = ["桌子", "椅子", "床", "空调", "热水器","冰箱"]
    @State private var tags: [String] = ["精装修", "近地铁", "带阳台"]
    @State private var petPolicy: Bool = false
    @State private var moveInRequirements: String = ""
    @State private var additionalFees: [String] = []
    
    
    
    
    var body: some View {
        VStack {
            ProgressView(value: viewModel.uploadProgress)
                .progressViewStyle(LinearProgressViewStyle())
            
            if let result = viewModel.responseData {
                let name = result.community
                Text("上传成功：\(name ?? "")")
                
            }
            else if let error = viewModel.uploadError {
                Text("上传失败：\(error.localizedDescription)")
            }
            else {
                EmptyView()
            }
            
            
            Button("上传数据") {
                
                let router = HouseApi.uploadHouse(images: images,
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
                                                  availableDate: availableDate,
                                                  leaseTerm: leaseTerm,
                                                  paymentMethod: paymentMethod,
                                                  decoration: decoration,
                                                  desc: desc,
                                                  facilities: facilities,
                                                  tags: tags,
                                                  petPolicy: petPolicy,
                                                  moveInRequirements: moveInRequirements,
                                                  additionalFees: additionalFees)
                
                
                viewModel.uploadData(router: router)
            }
        }
    }
}

//
//  HouseDetailView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/27.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapHouseView: View {
    var house: House // 添加这行来声明一个House类型的变量
//
//    var body: some View {
//        VStack {
//            Text(house.community ?? "") // 使用house对象的name属性
//            // 在这里添加更多UI元素来展示房源的详细信息
//        }
//        .navigationTitle("房源详情")
//        .navigationBarTitleDisplayMode(.inline)
//    }
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var currentLocation: CLLocationCoordinate2D?
    
    var body: some View {
        
        VStack(content: {
            
            Text("latitude: \(String(describing: locationManager.currentLocation?.latitude ?? 0))")
            
            Text("longitude: \(String(describing: locationManager.currentLocation?.longitude ?? 0))")
            
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: locationManager.currentLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )), showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
//                .onAppear {
//                    locationManager.startUpdatingLocation()
//                }
        })
        
            
        }
    
    
}

//#Preview {
//    HouseDetailView(house: House(from: "示例房源" as! Decoder))
//}

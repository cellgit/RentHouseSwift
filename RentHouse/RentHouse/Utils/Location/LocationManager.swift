//
//  LocationManager.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/2.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest // 设置定位精度
        self.locationManager.requestWhenInUseAuthorization() // 请求用户授权
        self.locationManager.startUpdatingLocation() // 开始定位
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location.coordinate // 更新当前位置
    }
}

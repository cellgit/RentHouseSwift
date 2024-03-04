//
//  CitySearchViewModel.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/4.
//

import Foundation
import SwiftUI
import Combine

class CitySearchViewModel: ObservableObject {
    @Published var sectionCityList = [CitySection]()
    
    @Published var cityList = [District]()
    
//    @Published var cityModel: District?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let service: SearchServiceProtocol
    
    init(service: SearchServiceProtocol) {
        self.service = service
        fetchCityList()
    }

    func fetchCityList() {
        isLoading = true
        service.fetchCityList()
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] datalist in
                self?.isLoading = false
                self?.sectionCityList = datalist.first?.districts ?? []
                
//                self?.cityList = districts
            })
            .store(in: &self.cancellables)
    }
    
    func fetchSearchCities(cityName: String) {
        isLoading = true
        service.fetchSearchCities(name: cityName)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error: \(error.localizedDescription)")
                }
                self.isLoading = false
            }, receiveValue: { [weak self] districts in
                self?.isLoading = false
                self?.cityList = districts
                
                debugPrint("self?.cityList ==== \(self?.cityList)")
            })
            .store(in: &self.cancellables)
    }
}

//
//  HomeViewModel.swift
//  RentHouse
//
//  Created by liuhongli on 2024/2/28.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var houses: [House]?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let service: HomeServiceProtocol
    
    init(service: HomeServiceProtocol) {
        self.service = service
        fetchHouses()
    }

    func fetchHouses() {
        isLoading = true
        //120.210792,30.246026
        service.fetchHouses(lon: "120.210792", lat: "30.246026", maxDistance: "5000000")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] data in
                self?.houses = data
            })
            .store(in: &cancellables)
    }
}

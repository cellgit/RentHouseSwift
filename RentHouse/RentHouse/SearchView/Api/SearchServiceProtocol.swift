//
//  SearchServiceProtocol.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/4.
//

import Foundation

import Combine

protocol SearchServiceProtocol {
    func fetchCityList() -> AnyPublisher<[CountryData], Error>
    
    func fetchSearchCities(name: String) -> AnyPublisher<[District], Error>
}

//
//  MapSearchManager.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/2.
//

import Foundation
import MapKit

class MapSearchManager {
    static let shared = MapSearchManager()
    
    private init() {}
    
    func search(for query: String, region: MKCoordinateRegion, completion: @escaping (Result<[MKMapItem], Error>) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response else {
                completion(.failure(NSError(domain: "MapSearchManagerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "未能找到结果"])))
                return
            }
            
            completion(.success(response.mapItems))
        }
    }
}

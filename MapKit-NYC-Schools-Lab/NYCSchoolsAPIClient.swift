//
//  NYCSchoolsAPIClient.swift
//  MapKit-NYC-Schools-Lab
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import NetworkHelper

struct NYCSchoolsAPIClient {
    
    static func getSchools(completion: @escaping(Result<[School], AppError>) -> ()) {
        
        let endpoint = "https://data.cityofnewyork.us/resource/uq7m-95z8.json"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.badURL(endpoint)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                do {
                    let schools = try JSONDecoder().decode([School].self, from: data)
                    completion(.success(schools))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}

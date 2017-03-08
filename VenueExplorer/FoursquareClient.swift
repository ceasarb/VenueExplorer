//
//  FoursquareClient.swift
//  VenueExplorer
//
//  Created by Ceaz on 2/18/17.
//  Copyright © 2017 Seize Software. All rights reserved.
//

import Foundation

class FoursquareClient {
    
    let clientId: String
    let clientSecret: String
    
    init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    func fetchVenuesFor(coordinate: Coordinate, query: String? = nil, searchRadius: Int? = nil, completion: @escaping (APIResult<[Venue]>) -> Void) {
        
        let searchEndpoint = FoursquareEndpoint.search(clientId: self.clientId, clientSecret: self.clientSecret, coordinate: coordinate, query: query, searchRadius: searchRadius)
        
        let networkProcessing = NetworkProcessing(request: searchEndpoint.request)
        
        networkProcessing.downloadJSON { (json, httpResponse, error) in
            // (1) Get back on Main Thread
            DispatchQueue.main.async {
                // (2) Turn JSON in [Venue]
                guard let json = json else {
                    if let err = error {
                        completion(.failure(err))
                    }
                    return
                }
                
                guard let response = json["response"] as? [String: Any], let venueDictionaries = response["venues"] as? [[String: Any]] else {
                    
                    let error = NSError(domain: DANetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                    completion(.failure(error))
                    return
                }
   
                
                // (3) Call Completion
                let venues = venueDictionaries.flatMap { venueDict in
                    return Venue(venueDict: venueDict)
                }
                completion(.success(venues))

            }
            
        }
        
    }
    
    func fetchData(url: URL, completion: @escaping (APIResult<Data>) -> Void) {
        
        let request = URLRequest(url: url)
        let networkProcessing = NetworkProcessing.init(request: request)
        
        networkProcessing.downloadData { (data, httpResponse, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                }
            }
        }
    }
    
    
    
}

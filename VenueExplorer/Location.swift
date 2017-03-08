//
//  Location.swift
//  VenueExplorer
//
//  Created by Ceaz on 2/17/17.
//  Copyright © 2017 Seize Software. All rights reserved.
//

import Foundation

struct Location {
    
    let coordinate: Coordinate?
    let distance: Double?
    let countryCode: String?
    let country: String?
    let state: String?
    let city: String?
    let streetAddress: String?
    let crossStreet: String?
    let postalCode: String?
    
    init?(locationDict: [String: Any]) {
        
        if let latitude = locationDict["lat"] as? Double,
            let longitude = locationDict["lng"] as? Double {
            self.coordinate = Coordinate(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = nil
        }
        
        self.distance = locationDict["distance"] as? Double
        self.countryCode = locationDict["cc"] as? String
        self.country = locationDict["country"] as? String
        self.state = locationDict["state"] as? String
        self.city = locationDict["city"] as? String
        self.streetAddress = locationDict["streetAddress"] as? String
        self.crossStreet = locationDict["crossStreet"] as? String
        self.postalCode = locationDict["postalCode"] as? String
        
    }
}

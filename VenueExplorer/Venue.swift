//
//  Venue.swift
//  VenueExplorer
//
//  Created by Ceaz on 2/17/17.
//  Copyright © 2017 Seize Software. All rights reserved.
//

import Foundation

struct Venue {
    let id: String
    let name: String
    let location: Location?
    let categoryName: String
    let checkins: Int
    let categoryIconURL: URL?
    var categoryIconSize = 88
    var url: URL?
    
    init?(venueDict: [String: Any]) {
        
        guard let id = venueDict["id"] as? String,
            let name = venueDict["name"] as? String,
            let categories = venueDict["categories"] as? [[String: Any]],
            let category = categories.first,
            let categoryName = category["name"] as? String,
            let stats = venueDict["stats"] as? [String: Any],
            let checkinsCount = stats["checkinsCount"] as? Int else {
                
                return nil
        }
        
        self.id = id
        self.name = name
        self.categoryName = categoryName
        self.checkins = checkinsCount
        
        if let urlString = venueDict["url"] as? String {
            self.url = URL(string: urlString)!
        } else {
            self.url = nil
        }
        
        if let locationDict = venueDict["location"] as? [String: Any] {
            self.location = Location(locationDict: locationDict)
        } else {
            self.location = nil
        }
        
        if let categoryIconDict = category["icon"] as? [String: Any],
            let prefix = categoryIconDict["prefix"] as? String,
            let suffix = categoryIconDict["suffix"] {
            
            let iconURLString = "\(prefix)\(self.categoryIconSize)\(suffix)"
            self.categoryIconURL = URL(string: iconURLString)
            
        } else {
            self.categoryIconURL = nil
        }
        
    }
    
}

//
//  Coordinate.swift
//  VenueExplorer
//
//  Created by Ceaz on 2/17/17.
//  Copyright © 2017 Seize Software. All rights reserved.
//

import Foundation

struct Coordinate: CustomStringConvertible {
    let latitude: Double
    let longitude: Double
    
    var description: String {
        return "\(latitude),\(longitude)"
    }
}

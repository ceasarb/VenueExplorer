//
//  APIResult.swift
//  VenueExplorer
//
//  Created by Ceaz on 2/18/17.
//  Copyright © 2017 Seize Software. All rights reserved.
//

import Foundation

/*
    Enum gives result of API. Contains two cases with associated values. Success Case with  value of T or generic type and Failure Case with value of Error type.
 */
enum APIResult<T> {
    case success(T)
    case failure(Error)
}

//
//  NetworkProcessing.swift
//  VenueExplorer
//
//  Created by Ceaz on 2/17/17.
//  Copyright © 2017 Seize Software. All rights reserved.
//

import Foundation

// Input: URLRequest
// Output: returns JSON, or raw data
// Algo: Make request to server, download data, return data

public let DANetworkingErrorDomain = "\(Bundle.main.bundleIdentifier).Networking Error"
public let MissingHTTPResponseError: Int = 10
public let UnexpectedResponseError: Int = 20

class NetworkProcessing {
    
    let request: URLRequest
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    init(request: URLRequest) {
        self.request = request
    }
    
    typealias JSON = [String: Any]
    typealias JSONHandler = (JSON?, HTTPURLResponse?, Error?) -> Void
    typealias DataHandler = (Data?, HTTPURLResponse?, Error?) -> Void
    
    func downloadJSON(completion: @escaping JSONHandler) {
        
        let dataTask = session.dataTask(with: self.request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")]
                let error = NSError(domain: DANetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completion(nil, nil, error as Error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completion(nil, httpResponse, error)
                }
            } else {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? JSON
                        completion(json, httpResponse, nil)
                    } catch let error as NSError {
                        completion(nil, httpResponse, error)
                    }
                default:
                    print("Received HTTP response code: \(httpResponse.statusCode) - was not handled in NetworkProcessing.swift")
                }
            }
        }
        
        dataTask.resume()
    }
    
    
    func downloadData(completion: @escaping DataHandler) {
        
        let dataTask = session.dataTask(with: self.request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")]
                let error = NSError(domain: DANetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completion(nil, nil, error as Error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completion(nil, httpResponse, error)
                }
            } else {
                switch httpResponse.statusCode {
                case 200:
                    completion(data, httpResponse, nil)
                default:
                    print("Received HTTP response code: \(httpResponse.statusCode) - was not handled in NetworkProcessing.swift")
                }
            }
        }
        
        dataTask.resume()

        
    }
    
    
    
    
    
    
}

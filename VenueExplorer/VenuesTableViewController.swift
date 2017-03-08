//
//  VenuesTableViewController.swift
//  VenueExplorer
//
//  Created by Ceaz on 2/20/17.
//  Copyright © 2017 Seize Software. All rights reserved.
//

import UIKit
import SafariServices
import MapKit

class VenuesTableViewController: UITableViewController {
    
    // MARK: @IBOutlets
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    var venues: [Venue] = [] {
        didSet {
            self.tableView.reloadData()
            self.addMapAnnotations()
        }
    }
    
    var coordinate: Coordinate? {
        didSet {
            self.fetchVenues()
        }
    }

    let locationManager = LocationManager()
    var clientID: String = "G31ZDXP3ZHXBEJR2ENG2NZ4JOLXVSWRYOSTE0JRIK0SQF3ZQ"
    var clientSecret: String = "VF1AOHTUIIUBLORHEOTLIFQTVUYGUG5XC4UBP1GZQOC2O3YG"
    var foursquareClient: FoursquareClient!
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK - Storyboard Identfier
    struct StoryboardIdentfier {
        static let venueCell = "VenueCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foursquareClient = FoursquareClient(clientId: clientID, clientSecret: clientSecret)
        //coordinate = Coordinate(latitude: 40.7, longitude: -74)
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Location Service
        locationManager.getPermission()
        locationManager.didGetLocation = { [weak self] coordinate in
            self?.coordinate = coordinate
        }
        
        mapView.delegate = self
        
        // Configure Search Bar
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        headerStackView.addSubview(searchController.searchBar)
    }
    
    @IBAction func fetchVenues() {
        if let coordinate = self.coordinate {
            foursquareClient.fetchVenuesFor(coordinate: coordinate, completion: { (result) in
                switch result {
                case .success(let venues):
                    self.venues = venues
                    self.refreshControl?.endRefreshing()
                case .failure(let error):
                    
                    let alert = UIAlertController(title: "Oops!", message: "\(error)", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                    
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    print(error)
                }
            })
        }
    }
    
    // MARK: - Map Annotations
    
    func addMapAnnotations() {
        
        self.removeAnnotations()
        // (1) Loop through venues
        if venues.count > 0 {
            let annotations: [MKPointAnnotation] = venues.map({ venue in
                
                // (2) create a annotation object
                let point = MKPointAnnotation()
                
                if let coordinate = venue.location?.coordinate {
                    point.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    point.title = venue.name
                    point.subtitle = venue.categoryName
                }
                
                return point
            })
            
            // (3) add annotations to the mapview
            mapView.addAnnotations(annotations)
        }
    }
    
    func removeAnnotations() {
        if mapView.annotations.count != 0 {
            for annotation in mapView.annotations {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    
}


// MARK: - UITableViewDataSource
extension VenuesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardIdentfier.venueCell, for: indexPath) as! VenueTableViewCell
        let venue = venues[indexPath.row]
        
        cell.foursquareClient = self.foursquareClient
        cell.venue = venue
        
        return cell
    }

    
}

// MARK: UITableViewDelegate
extension VenuesTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeight: CGFloat = 71.0
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let venue = self.venues[indexPath.row]
        
        if let url = venue.url {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Oops!", message: "Looks like this venue does not have a website", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}

// MARK: MKMapViewDelegate
extension VenuesTableViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var region = MKCoordinateRegion()
        region.center = mapView.userLocation.coordinate
        region.span.latitudeDelta = 0.005
        region.span.longitudeDelta = 0.005
        mapView.setRegion(region, animated: true)

    }
    
    
}

// MARK: - UISearchResultUpdating 
extension VenuesTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let coordinate = coordinate {
            foursquareClient.fetchVenuesFor(coordinate: coordinate, query: searchController.searchBar.text, completion: { (result) in
                switch result {
                case .success(let venues):
                    self.venues = venues
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
}












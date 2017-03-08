//
//  VenueTableViewCell.swift
//  VenueExplorer
//
//  Created by Ceaz on 2/20/17.
//  Copyright © 2017 Seize Software. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var venueCategoryImageView: UIImageView!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var venueCategoryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var checkinLabel: UILabel!
    
    //MARK: - Properties
    var venue: Venue! {
        didSet {
            self.updateUI()
        }
    }
    
    var foursquareClient: FoursquareClient!
    
    func updateUI() {
        venueNameLabel.text = venue.name
        venueCategoryLabel.text = venue.categoryName
        checkinLabel.text = "\(venue.checkins)"
        
        if let distance = venue.location?.distance {
            distanceLabel.text = "\(distance)mi"
        } else {
            distanceLabel.isHidden = true
        }
        
        if let foursquareClient = foursquareClient, let categoryURL = venue.categoryIconURL {
            foursquareClient.fetchData(url: categoryURL, completion: { (result) in
               
                switch result {
                case .success(let data):
                    self.venueCategoryImageView.image = UIImage(data: data)
                    self.venueCategoryImageView.backgroundColor = UIColor.random()
                    self.venueCategoryImageView.layer.cornerRadius = self.venueCategoryImageView.bounds.width / 2.0
                    self.venueCategoryImageView.layer.masksToBounds = true
                case .failure(let error):
                    print(error)
                }
                
            })
        }
    }
}

private extension UIColor {
    
    class func random() -> UIColor {
        var colors = [
            UIColor(red: 245/255.0, green: 166/255.0, blue: 35/255.0, alpha: 1.0),
            UIColor(red: 144/255.0, green: 19/255.0, blue: 254/255.0, alpha: 1.0),
            UIColor(red: 249/255.0, green: 103/255.0, blue: 30/255.0, alpha: 1.0),
            UIColor(red: 35/255.0, green: 141/255.0, blue: 255/255.0, alpha: 1.0),
            UIColor(red: 255/255.0, green: 45/255.0, blue: 85/255.0, alpha: 1.0)
        ]
        
        let random = Int(arc4random()) % colors.count
        return colors[random]
    }
}










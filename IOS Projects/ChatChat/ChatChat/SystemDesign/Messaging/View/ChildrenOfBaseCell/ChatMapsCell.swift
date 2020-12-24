//
//  ChatMapsCell.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 11/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit
import MapKit

class ChatMapsCell: BaseCell {
    
    @IBOutlet weak var map: MKMapView!
    var longitude: CLLocationDegrees = 0
    var latitude: CLLocationDegrees = 0
    var geoLocation: CLLocationCoordinate2D!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.map.layer.cornerRadius = 15
        self.map.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadCoordinates(withCompletion completion: @escaping () -> Void) {
        // Remove old annotations
        map.removeAnnotations(map.annotations)

        geoLocation = CLLocationCoordinate2DMake(latitude, longitude)

        let geoPin = MKPointAnnotation()
        geoPin.coordinate = geoLocation
        map.addAnnotation(geoPin)

        let viewRegion = MKCoordinateRegion(center: geoLocation, latitudinalMeters: CLLocationDistance(1500), longitudinalMeters: CLLocationDistance(1500))

        map.setRegion(viewRegion, animated: false)

        // Init tap handling
        let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(handleMapViewGesture))
        map.addGestureRecognizer(tapGestureRec)
    }
    
    @objc func handleMapViewGesture() {
        var mapItems: [AnyHashable] = []

        let placemark = MKPlacemark(coordinate: geoLocation)
        let location = MKMapItem(placemark: placemark)
        location.name = "📍 A Location"
        mapItems.append(location)

        var launchOptions: [AnyHashable : Any] = [:]
        // Open apple maps
        if let mapItems = mapItems as? [MKMapItem] {
            MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions as? [String : Any])
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

}

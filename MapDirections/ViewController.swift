//
//  ViewController.swift
//  MapDirections
//
//  Created by Amandeep Singh on 28/04/18.
//  Copyright © 2018 Amandeep Singh. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var mapKitView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
}

    @IBAction func searchLocation(_ sender: UIBarButtonItem) {
        mapKitView.delegate = self
        mapKitView.showsScale = true
        mapKitView.showsPointsOfInterest = true
        mapKitView.showsUserLocation = true
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
            
        }
        
        
        
       let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(locationManager.location!.coordinate.latitude, locationManager.location!.coordinate.longitude)))
        let destItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(-33.8568, 151.2153)))
        
        let directionReq = MKDirectionsRequest()
        
        directionReq.source = sourceItem
        directionReq.destination = destItem
        directionReq.transportType = .any
        
        let directions = MKDirections(request: directionReq)
        directions.calculate (completionHandler: { (response, error) in
            
            guard let response = response else{
                if let error = error{
                    print("Something went wrong! \n \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.mapKitView.add(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapKitView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        })
        
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }

}


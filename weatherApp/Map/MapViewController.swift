//
//  MapViewController.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 28/10/1447 AH.
//

import UIKit
import MapKit
import CoreLocation
class MapViewController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        configureMapView()
        locationManager.requestWhenInUseAuthorization()
       
    }
    
}
private extension MapViewController {
    
    func configureMapView() {
        mapView.showsUserLocation = true
    }
}
extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus == .authorizedWhenInUse ||
                  manager.authorizationStatus == .authorizedAlways else {
                return
            }
        locationManager.startUpdatingLocation()
           
       }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let coordinate = location.coordinate
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        }
}

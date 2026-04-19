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
    @IBOutlet private weak var weatherCardView: UIView!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var conditionLabel: UILabel!

    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    private var selectedWeatherResponse: WeatherResponse?
    private var selectedCoordinate: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        configureMapView()
        configureWeatherCardInteraction()
        locationManager.requestWhenInUseAuthorization()
        weatherCardView.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureWeatherCardView()
    }
}
private extension MapViewController {
    func configureMapView() {
        mapView.showsUserLocation = true
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleMapTap(_:))
        )
        mapView.addGestureRecognizer(tapGestureRecognizer)
    }
    func configureWeatherCardInteraction() {
        weatherCardView.isUserInteractionEnabled = true
        weatherCardView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleWeatherCardTap))
        )
    }
    @objc func handleWeatherCardTap() {
        presentWeatherBottomSheet()
    }
    @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        selectedCoordinate = coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        weatherService.fetchCurrentWeather(lat: coordinate.latitude, lon: coordinate.longitude) { result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    self.selectedWeatherResponse = weatherResponse
                    self.updateWeatherCard()
                    self.weatherCardView.isHidden = false
                }
            case .failure:
                break
            }
        }
    }
    func configureWeatherCardView() {
        weatherCardView.layer.cornerRadius = 24
        weatherCardView.clipsToBounds = true
        weatherCardView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.20)
    }
    func updateWeatherCard() {
        guard let weatherResponse = selectedWeatherResponse else {
            return
        }

        cityLabel.text = weatherResponse.name
        tempLabel.text = "\(Int(weatherResponse.main.temp))°"
        conditionLabel.text = weatherResponse.weather.first?.description.capitalized ?? "Clear"
    }
    func presentWeatherBottomSheet() {
        let weatherViewController = WeatherViewController()

        guard let selectedCoordinate else {
            return
        }

        weatherViewController.selectedLatitude = selectedCoordinate.latitude
        weatherViewController.selectedLongitude = selectedCoordinate.longitude
        present(weatherViewController, animated: true)
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
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard !(view.annotation is MKUserLocation) else {
            return
        }

        guard selectedWeatherResponse != nil else {
            return
        }
        weatherCardView.isHidden = false
    }
}

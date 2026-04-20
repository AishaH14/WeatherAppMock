//
//  MapViewController.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 28/10/1447 AH.
//
import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!

    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()

    private var selectedWeatherResponse: WeatherResponse?
    private var selectedCoordinate: CLLocationCoordinate2D?
    private var hideCardWorkItem: DispatchWorkItem?

    private lazy var weatherCard: CurrentWeatherCell = {
        let nib = UINib(nibName: Constants.currentWeatherCell, bundle: nil)
        guard let cell = nib.instantiate(withOwner: nil, options: nil).first as? CurrentWeatherCell else {
            assertionFailure( "CurrentWeatherCell not found")
            return CurrentWeatherCell() }

        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.isHidden = true
        cell.alpha = 0
        cell.isUserInteractionEnabled = true

        if let headerView = cell.viewWithTag(100) {
            headerView.layer.cornerRadius = 24
            headerView.layer.masksToBounds = true
            headerView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        }

        cell.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(openWeatherPopup))
        )

        return cell
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        mapView.delegate = self

        configureMapView()
        setupWeatherCard()

        locationManager.requestWhenInUseAuthorization()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutWeatherCard()
    }
}

private extension MapViewController {
    func configureMapView() {
        mapView.showsUserLocation = true

        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleMapTap(_:))
        )
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self

        mapView.addGestureRecognizer(tapGestureRecognizer)
    }

    func setupWeatherCard() {
        view.addSubview(weatherCard)
        view.bringSubviewToFront(weatherCard)
        layoutWeatherCard()
    }

    func layoutWeatherCard() {
        weatherCard.frame = CGRect(
            x: 16,
            y: view.bounds.height - 220,
            width: view.bounds.width - 32,
            height: 140
        )
    }

    func showWeatherCard() {
        hideCardWorkItem?.cancel()

        weatherCard.transform = CGAffineTransform(translationX: 0, y: 20)
        weatherCard.alpha = 0
        weatherCard.isHidden = false
        view.bringSubviewToFront(weatherCard)

        UIView.animate(withDuration: 0.25) {
            self.weatherCard.alpha = 1
            self.weatherCard.transform = .identity
        }

        let workItem = DispatchWorkItem { [weak self] in
            self?.hideWeatherCard()
        }

        hideCardWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: workItem)
    }

    func hideWeatherCard() {
        UIView.animate(withDuration: 0.3, animations: {
            self.weatherCard.alpha = 0
            self.weatherCard.transform = CGAffineTransform(translationX: 0, y: 120)
        }) { _ in
            self.weatherCard.isHidden = true
            self.weatherCard.transform = .identity
        }
    }

    @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

        selectedCoordinate = coordinate

        addPin(at: coordinate)
        mapView.setCenter(coordinate, animated: true)

        hideCardWorkItem?.cancel()
        weatherCard.alpha = 1
        weatherCard.isHidden = true

        weatherService.fetchCurrentWeather(
            lat: coordinate.latitude,
            lon: coordinate.longitude
        ) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let weatherResponse):
                    self.selectedWeatherResponse = weatherResponse
                    self.weatherCard.configure(with: weatherResponse)
                    self.showWeatherCard()

                case .failure(let error):
                    print("fetchCurrentWeather failed: \(error.localizedDescription)")
                }
            }
        }
    }

    func addPin(at coordinate: CLLocationCoordinate2D) {
        let nonUserAnnotations = mapView.annotations.filter { !($0 is MKUserLocation) }
        mapView.removeAnnotations(nonUserAnnotations)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }

    @objc func openWeatherPopup() {
        let weatherViewController = WeatherViewController(
            nibName: "WeatherViewController",
            bundle: nil
        )

        guard let selectedCoordinate else { return }

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

extension MapViewController: MKMapViewDelegate { }

extension MapViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}

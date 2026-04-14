//
//  WeatherDetailViewController.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 27/09/1447 AH.
//
import UIKit

class WeatherDetailViewController: UIViewController, UICalendarSelectionSingleDateDelegate{
    let gradient = CAGradientLayer()
    var forecastItems: [ForecastItem] = []
    var calendarOverlayView: UIControl?
    var calendarContainerView: UIView?
    var calendarView: UICalendarView?
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
       
        guard let dateComponents = dateComponents,
              let date = Calendar.current.date(from: dateComponents) else { return }

        selectedDate = date
        updateFullDateLabel(with: date)
        updateWeatherForSelectedDate(date)
        updateSelectedDateLabel(with: date)
        
    }
    @IBOutlet weak var fullDateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    
    var selectedDate = Date()
    var dividerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fullDateLabel.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        fullDateLabel.textAlignment = .center
        fullDateLabel.clipsToBounds = true
        applyWeatherGradient()
        view.backgroundColor = .clear
        updateFullDateLabel(with: selectedDate)
        updateWeatherForSelectedDate(selectedDate)
        updateSelectedDateLabel(with: selectedDate)
        
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(fullDateLabelTapped))
        fullDateLabel.isUserInteractionEnabled = true
        fullDateLabel.addGestureRecognizer(tap)

        hideCalendarPopup()
        setupDivider()
    
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = view.bounds
        fullDateLabel.layer.cornerRadius = 10
        fullDateLabel.clipsToBounds = true
    }
    func updateFullDateLabel(with date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "d MMMM yyyy"
        fullDateLabel.text = formatter.string(from: date)
    }

    func applyWeatherGradient() {
        let hour = Calendar.current.component(.hour, from: Date())
        let isDay = hour >= 6 && hour < 18
        
        gradient.frame = view.bounds
        gradient.colors = WeatherGradientProvider.colors(isDay: isDay)
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        if gradient.superlayer == nil {
            view.layer.insertSublayer(gradient, at: 0)
        }
    }
    
    
    func setupDivider() {
        dividerView = UIView()
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = UIColor.white.withAlphaComponent(0.3)

        view.addSubview(dividerView)

        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: selectedDateLabel.bottomAnchor, constant: 20),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    @objc func fullDateLabelTapped() {
        showCalendarPopup()
    }
    func updateWeatherForSelectedDate(_ date: Date) {
        guard !forecastItems.isEmpty else { return }

        let calendar = Calendar.current

        let sameDayItems = forecastItems.filter {
            let itemDate = Date(timeIntervalSince1970: TimeInterval($0.dt))
            return calendar.isDate(itemDate, inSameDayAs: date)
        }

        guard !sameDayItems.isEmpty else { return }

        let selectedItem = sameDayItems.min { first, second in
                let firstDate = Date(timeIntervalSince1970: TimeInterval(first.dt))
                let secondDate = Date(timeIntervalSince1970: TimeInterval(second.dt))

                let firstHour = abs(calendar.component(.hour, from: firstDate) - 12)
                let secondHour = abs(calendar.component(.hour, from: secondDate) - 12)

                return firstHour < secondHour
            } ?? sameDayItems[0]

            tempLabel.text = "\(Int(selectedItem.main.temp))°"

        
        let condition = selectedItem.weather.first?.main ?? "Clear"
        let weatherType = WeatherType(rawValue: condition) ?? .clear

        weatherImageView.image = weatherType.icon
        weatherImageView.tintColor = weatherType.color
    }
    func updateSelectedDateLabel(with date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        selectedDateLabel.text = formatter.string(from: date)
    }
    func showCalendarPopup() {
        if calendarOverlayView != nil { return }

        let overlay = UIControl()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        overlay.addTarget(self, action: #selector(hideCalendarPopup), for: .touchUpInside)
        view.addSubview(overlay)

        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 16
        container.clipsToBounds = true
        overlay.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: fullDateLabel.bottomAnchor, constant: 8),
            container.centerXAnchor.constraint(equalTo: fullDateLabel.centerXAnchor),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.widthAnchor.constraint(equalToConstant: 320),
            container.heightAnchor.constraint(equalToConstant: 340)
        ])

        let calendar = UICalendarView()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US")
        calendar.tintColor = .systemBlue

        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendar.selectionBehavior = selection

        let components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        selection.setSelected(components, animated: false)

        container.addSubview(calendar)

        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            calendar.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            calendar.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            calendar.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8)
        ])


        calendarOverlayView = overlay
        calendarContainerView = container
        calendarView = calendar
    }
    @objc func hideCalendarPopup() {
        calendarOverlayView?.removeFromSuperview()
        calendarOverlayView = nil
        calendarContainerView = nil
        calendarView = nil
    }
    
}

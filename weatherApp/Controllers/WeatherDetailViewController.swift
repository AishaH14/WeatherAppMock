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
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
       
        guard let dateComponents = dateComponents,
              let date = Calendar.current.date(from: dateComponents) else { return }

        selectedDate = date
        updateFullDateLabel(with: date)
        updateWeatherForSelectedDate(date)
        updateSelectedDateLabel(with: date)
        calendarPopupView.isHidden = true
    }
    @IBOutlet weak var calendarPopupView: UIView!
    @IBOutlet weak var fullDateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    var calendarView: UICalendarView!
    var selectedDate = Date()
    var dividerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fullDateLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        fullDateLabel.textAlignment = .center
        fullDateLabel.clipsToBounds = true
        applyWeatherGradient()
        view.backgroundColor = .clear
        updateFullDateLabel(with: selectedDate)
        updateWeatherForSelectedDate(selectedDate)
        updateSelectedDateLabel(with: selectedDate)
        
        calendarPopupView.isHidden = true
        calendarPopupView.layer.cornerRadius = 16
        calendarPopupView.clipsToBounds = true
        calendarPopupView.layer.borderWidth = 1
        calendarPopupView.layer.borderColor = UIColor.systemGray5.cgColor

        let tap = UITapGestureRecognizer(target: self, action: #selector(fullDateLabelTapped))
        fullDateLabel.isUserInteractionEnabled = true
        fullDateLabel.addGestureRecognizer(tap)

        setupCalendarView()
        setupDivider()
    
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = view.bounds
        fullDateLabel.layer.cornerRadius = fullDateLabel.frame.height / 2
        fullDateLabel.clipsToBounds = true
    }
    func updateFullDateLabel(with date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE, d MMMM yyyy"
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
    @objc func fullDateLabelTapped() {
        calendarPopupView.isHidden.toggle()
    }
    func setupCalendarView() {
        calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.locale = Locale(identifier: "en_US")
        calendarView.tintColor = .systemBlue

        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection

        let components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        selection.setSelected(components, animated: false)

        calendarPopupView.addSubview(calendarView)

        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: calendarPopupView.topAnchor, constant: 8),
            calendarView.bottomAnchor.constraint(equalTo: calendarPopupView.bottomAnchor, constant: -8),
            calendarView.leadingAnchor.constraint(equalTo: calendarPopupView.leadingAnchor, constant: 8),
            calendarView.trailingAnchor.constraint(equalTo: calendarPopupView.trailingAnchor, constant: -8)
        ])
    }
    
    func setupDivider() {
        dividerView = UIView()
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = UIColor.white.withAlphaComponent(0.3)

        view.addSubview(dividerView)

        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: calendarPopupView.bottomAnchor, constant: 20),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
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
    
}

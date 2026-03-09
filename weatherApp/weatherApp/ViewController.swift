//
//  ViewController.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 15/09/1447 AH.
//
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CurrentWeatherCell", bundle: nil),
                                  forCellReuseIdentifier: "CurrentWeatherCell")
        tableView.register(UINib(nibName: "HourlyCell", bundle: nil),
                              forCellReuseIdentifier: "HourlyCell")
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeatherCell", for: indexPath) as! CurrentWeatherCell

            cell.cityLabel.text = "Jeddah"
            cell.tempLabel.text = "24°"
            cell.weatherLabel.text = "Sunny"
            cell.weatherImage.image = UIImage(systemName: "location.fill")
            cell.weatherImage.tintColor = .white

            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 220
        }
    }
    



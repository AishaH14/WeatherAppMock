//
//  ViewController.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 15/09/1447 AH.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topCard: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        topCard.layer.cornerRadius = 24
        topCard.clipsToBounds = true
    }


}


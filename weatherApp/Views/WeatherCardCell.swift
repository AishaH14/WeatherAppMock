//
//  WeatherCardCell.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 26/09/1447 AH.
//

import UIKit

class WeatherCardCell: UICollectionViewCell {
    @IBOutlet weak var arcView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var lineContainerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        imageLabel.tintColor = UIColor.white.withAlphaComponent(0.7)
        imageLabel.contentMode = .scaleAspectFit
        imageLabel.backgroundColor = .clear
        cardView.layer.cornerRadius = 22
        cardView.clipsToBounds = true
        
        
        lineContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        let hour = Calendar.current.component(.hour, from: Date())
        _ = hour >= 6 && hour < 18
        
        WeatherTheme.applyGradient(to: cardView)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let isSunrise = titleLabel.text == "SUNRISE"
        
        lineContainerView.isHidden = !isSunrise
        arcView.isHidden = !isSunrise
        
        if isSunrise {
            drawSunArc()
        } else {
            arcView.layer.sublayers?.removeAll()
        }
    }
    
    func drawSunArc() {
           arcView.layer.sublayers?.removeAll()

           let width = arcView.bounds.width
           let height = arcView.bounds.height

           guard width > 0, height > 0 else { return }

          
           let horizonY = height * 0.62

           
           let path = UIBezierPath()
           path.move(to: CGPoint(x: -8, y: horizonY + 25))

           path.addCurve(
               to: CGPoint(x: width + 8, y: horizonY + 25),
               controlPoint1: CGPoint(x: width * 0.28, y: horizonY - 24),
               controlPoint2: CGPoint(x: width * 0.72, y: horizonY - 24)
           )

           let arcLayer = CAShapeLayer()
           arcLayer.path = path.cgPath
           arcLayer.strokeColor = UIColor.black.withAlphaComponent(0.18).cgColor
           arcLayer.fillColor = UIColor.clear.cgColor
           arcLayer.lineWidth = 4
           arcLayer.lineCap = .round

           arcView.layer.addSublayer(arcLayer)

          
           let sunSize: CGFloat = 10
           let sunLayer = CALayer()
           sunLayer.frame = CGRect(x: width * 0.14, y: horizonY - 5, width: sunSize, height: sunSize)
           sunLayer.backgroundColor = UIColor.white.cgColor
           sunLayer.cornerRadius = sunSize / 2
           sunLayer.shadowColor = UIColor.white.cgColor
           sunLayer.shadowOpacity = 0.9
           sunLayer.shadowRadius = 8
           sunLayer.shadowOffset = .zero

           arcView.layer.addSublayer(sunLayer)
       }
   }

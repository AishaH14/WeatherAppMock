//
//  WeatherCardCell.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 26/09/1447 AH.
//

import UIKit

class WeatherCardCell: UICollectionViewCell {
    static let identifier = "WeatherCardCell"
    private enum Constants {
            static let sunriseTitle = "SUNRISE"
            static let imageTintAlpha: CGFloat = 0.7
            static let lineAlpha: CGFloat = 0.5
            static let cornerRadius: CGFloat = 22
            
            static let dayStartHour = 6
            static let dayEndHour = 18
            
            static let horizonYMultiplier: CGFloat = 0.62
            static let pathStartX: CGFloat = -8
            static let pathEndOffset: CGFloat = 8
            static let pathVerticalOffset: CGFloat = 25
            static let controlPointYInset: CGFloat = 24
            static let firstControlPointXMultiplier: CGFloat = 0.28
            static let secondControlPointXMultiplier: CGFloat = 0.72
            
            static let arcStrokeAlpha: CGFloat = 0.18
            static let arcLineWidth: CGFloat = 4
            
            static let sunSize: CGFloat = 10
            static let sunXMultiplier: CGFloat = 0.14
            static let sunYOffset: CGFloat = -5
            static let sunShadowOpacity: Float = 0.9
            static let sunShadowRadius: CGFloat = 8
        }

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
        
        imageLabel.tintColor = UIColor.white.withAlphaComponent(Constants.imageTintAlpha)
        imageLabel.contentMode = .scaleAspectFit
        imageLabel.backgroundColor = .clear
        cardView.layer.cornerRadius = 22
        cardView.clipsToBounds = true
        
        
        lineContainerView.backgroundColor = UIColor.white.withAlphaComponent(Constants.lineAlpha)
        let hour = Calendar.current.component(.hour, from: Date())
        let isDay = hour >= 6 && hour < 18

       
        cardView.applyWeatherGradient(colors: WeatherTheme.colors(isDay: isDay))
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let isSunrise = titleLabel.text == Constants.sunriseTitle
        
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
        path.move(to: CGPoint(x: Constants.pathStartX, y: horizonY + Constants.pathVerticalOffset))

           path.addCurve(
            to: CGPoint(x: width + Constants.pathEndOffset, y: horizonY + Constants.pathVerticalOffset),
            controlPoint1: CGPoint(x: width * Constants.firstControlPointXMultiplier, y: horizonY - Constants.controlPointYInset),
            controlPoint2: CGPoint(x:width * Constants.secondControlPointXMultiplier, y: horizonY - Constants.controlPointYInset),
           )

           let arcLayer = CAShapeLayer()
           arcLayer.path = path.cgPath
        arcLayer.strokeColor = UIColor.black.withAlphaComponent(Constants.arcStrokeAlpha).cgColor
           arcLayer.fillColor = UIColor.clear.cgColor
           arcLayer.lineWidth = Constants.arcLineWidth
           arcLayer.lineCap = .round

           arcView.layer.addSublayer(arcLayer)

          
           
           let sunLayer = CALayer()
           sunLayer.frame = CGRect(x: width * Constants.sunXMultiplier,
                                   y: horizonY + Constants.sunYOffset, width: Constants.sunSize,
                                   height: Constants.sunSize)
           sunLayer.backgroundColor = UIColor.white.cgColor
        sunLayer.cornerRadius = Constants.sunSize / 2
           sunLayer.shadowColor = UIColor.white.cgColor
           sunLayer.shadowOpacity = Constants.sunShadowOpacity
           sunLayer.shadowRadius = Constants.sunShadowRadius
           sunLayer.shadowOffset = .zero

           arcView.layer.addSublayer(sunLayer)
       }
   }

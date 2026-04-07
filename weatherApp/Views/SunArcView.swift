//
//  SunArcView.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 19/10/1447 AH.
//

import UIKit

final class SunArcView: UIView {
  
    enum SunArcDrawer {
        
        private enum Constants {
            static let horizonYMultiplier: CGFloat = 0.33
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
            static let sunYOffset: CGFloat = -6
            static let sunShadowOpacity: Float = 0.9
            static let sunShadowRadius: CGFloat = 8
        }
        
        static func draw(on view: UIView) {
            remove(from: view)
            
            let width = view.bounds.width
            let height = view.bounds.height
            
            guard width > 0, height > 0 else { return }
            
            let horizonY = height * Constants.horizonYMultiplier
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: Constants.pathStartX, y: horizonY + Constants.pathVerticalOffset))
            path.addCurve(
                to: CGPoint(x: width + Constants.pathEndOffset, y: horizonY + Constants.pathVerticalOffset),
                controlPoint1: CGPoint(x: width * Constants.firstControlPointXMultiplier, y: horizonY - Constants.controlPointYInset),
                controlPoint2: CGPoint(x: width * Constants.secondControlPointXMultiplier, y: horizonY - Constants.controlPointYInset)
            )
            
            let arcLayer = CAShapeLayer()
            arcLayer.name = "sunriseArcLayer"
            arcLayer.path = path.cgPath
            arcLayer.strokeColor = UIColor.black.withAlphaComponent(Constants.arcStrokeAlpha).cgColor
            arcLayer.fillColor = UIColor.clear.cgColor
            arcLayer.lineWidth = Constants.arcLineWidth
            arcLayer.lineCap = .round
            view.layer.addSublayer(arcLayer)
            
            let sunLayer = CALayer()
            sunLayer.name = "sunriseSunLayer"
            sunLayer.frame = CGRect(
                x: width * Constants.sunXMultiplier,
                y: horizonY + Constants.sunYOffset,
                width: Constants.sunSize,
                height: Constants.sunSize
            )
            sunLayer.backgroundColor = UIColor.white.cgColor
            sunLayer.cornerRadius = Constants.sunSize / 2
            sunLayer.shadowColor = UIColor.white.cgColor
            sunLayer.shadowOpacity = Constants.sunShadowOpacity
            sunLayer.shadowRadius = Constants.sunShadowRadius
            sunLayer.shadowOffset = .zero
            view.layer.addSublayer(sunLayer)
        }
        
        static func remove(from view: UIView) {
            view.layer.sublayers?
                .filter { $0.name == "sunriseArcLayer" || $0.name == "sunriseSunLayer" }
                .forEach { $0.removeFromSuperlayer() }
        }
    }
}

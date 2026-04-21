//
//  LoadingPresenter.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 04/11/1447 AH.
//

import UIKit

enum LoadingPresenter {
    
    private static let overlayTag = 999_001
    
    static func show(on view: UIView) {
        hide(from: view)
        
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView.tag = overlayTag
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.startAnimating()
        
        overlayView.addSubview(indicator)
        view.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        ])
    }
    
    static func hide(from view: UIView) {
        view.viewWithTag(overlayTag)?.removeFromSuperview()
    }
}

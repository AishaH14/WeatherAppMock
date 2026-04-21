//
//  MessagePresenter.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 04/11/1447 AH.
//

import UIKit
import SwiftMessages

enum MessagePresenter {
    
    static func showError(_ message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureTheme(.error)
        view.configureDropShadow()
        view.configureContent(
            title: "Error",
            body: message
        )
        view.button?.isHidden = true
        
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        config.duration = .seconds(seconds: 2.5)
        config.dimMode = .none
        
        SwiftMessages.show(config: config, view: view)
    }
    
    static func showSuccess(_ message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureTheme(.success)
        view.configureDropShadow()
        view.configureContent(
            title: "Success",
            body: message
        )
        view.button?.isHidden = true
        
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        config.duration = .seconds(seconds: 2.5)
        config.dimMode = .none
        
        SwiftMessages.show(config: config, view: view)
    }
}

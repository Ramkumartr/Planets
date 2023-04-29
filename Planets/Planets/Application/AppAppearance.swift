//
//  AppAppearance.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import Foundation
import UIKit

final class AppAppearance {
    
    static func setupAppearance() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = UIColor(red: 37/255.0, green: 37/255.0, blue: 37.0/255.0, alpha: 1.0)
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}



extension UINavigationController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIColor {
    
    enum Text {
        static let charcoal: UIColor = UIColor.charcoal
        static let grey: UIColor = UIColor.grey
        static let white: UIColor = UIColor.white
    }
    
    enum Background {
        static let charcoal: UIColor = UIColor.charcoal
    }
    
    enum Brand {
        static let popsicle40: UIColor = UIColor.popsicle40
    }
    
    private static let charcoal: UIColor = UIColor(red: 22 / 255.0, green: 22 / 255.0, blue: 22 / 255.0, alpha: 1)
    private static let grey: UIColor = UIColor(red: 81 / 255.0, green: 81 / 255.0, blue: 83 / 255.0, alpha: 1)
    private static let popsicle40: UIColor = UIColor(red: 156 / 255.0, green: 44 / 255.0, blue: 243 / 255.0, alpha: 1)
    private static let white: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
}

extension UIFont {
    
    enum Heading {
        static var medium: UIFont =  UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let small: UIFont =  UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let extraSmall: UIFont = UIFont.systemFont(ofSize: 8, weight: .semibold)
    }
    
}

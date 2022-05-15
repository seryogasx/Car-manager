//
//  AppFonts.swift
//  CarManager
//
//  Created by Сергей Петров on 20.11.2021.
//

import Foundation
import UIKit

struct AppFonts {
    private static let mainTitle = UIFont.boldSystemFont(ofSize: 22)
    private static let secondaryTitle = UIFont.boldSystemFont(ofSize: 16)
    
    static func secondaryTitle(string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: secondaryTitle])
    }
    
    static func mainTitle(string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: mainTitle])
    }
}

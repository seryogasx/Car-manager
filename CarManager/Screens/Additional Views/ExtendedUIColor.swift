//
//  ExtendedUIColor.swift
//  CarManager
//
//  Created by Сергей Петров on 02.06.2022.
//

import Foundation
import UIKit

extension UIColor {
    static func generateColors(count: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 1...count {
            colors.append(UIColor(red: CGFloat.random(in: 0...1),
                                  green: CGFloat.random(in: 0...1),
                                  blue: CGFloat.random(in: 0...1),
                                  alpha: 1.0))
        }
        return colors
    }
}

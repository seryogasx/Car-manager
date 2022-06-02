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
            colors.append(UIColor(red: .random(in: 0...CGFloat(arc4random()) / CGFloat(UInt32.max)),
                                  green: .random(in: 0...CGFloat(arc4random()) / CGFloat(UInt32.max)),
                                  blue: .random(in: 0...CGFloat(arc4random()) / CGFloat(UInt32.max)),
                                  alpha: 1.0))
        }
        return colors
    }
}

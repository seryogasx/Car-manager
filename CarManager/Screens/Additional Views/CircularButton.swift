//
//  CircularButton.swift
//  CarManager
//
//  Created by Сергей Петров on 19.05.2022.
//

import Foundation
import UIKit

class CircularButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.image = UIImage(named: "CompleteButtonImage")?.resizeImage(to: self.frame.size)
    }
}

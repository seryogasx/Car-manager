//
//  CircularImageView.swift
//  CarManager
//
//  Created by Сергей Петров on 15.05.2022.
//

import Foundation
import UIKit

class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
    }
}

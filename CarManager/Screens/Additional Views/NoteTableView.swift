//
//  NoteTableView.swift
//  CarManager
//
//  Created by Сергей Петров on 31.05.2022.
//

import Foundation
import UIKit

class NoteTableView: UITableView {
    
    let sectionsCount: Int = 2
    
    func setup(estimatedRowHeight: CGFloat, rowHeight: CGFloat) {
        self.register(CarDetailTableViewAlertCell.self, forCellReuseIdentifier: CarDetailTableViewAlertCell.reuseIdentifier)
        self.register(CarDetailTableViewNoteCell.self, forCellReuseIdentifier: CarDetailTableViewNoteCell.reuseIdentifier)
        self.estimatedRowHeight = estimatedRowHeight
        self.rowHeight = rowHeight
    }
}

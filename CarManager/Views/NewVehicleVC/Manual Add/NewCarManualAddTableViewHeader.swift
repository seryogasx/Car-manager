//
//  NewCarManualAddTableViewHeader.swift
//  CarManager
//
//  Created by Сергей Петров on 30.10.2021.
//

import UIKit

class NewCarManualAddTableViewHeader: UITableViewHeaderFooterView {
    static let reuseIdentifier = String(describing: self)
    
    var labelView: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        labelView = UILabel()
        contentView.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        labelView.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        labelView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        labelView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(header: String) {
        labelView.text = header
    }
}

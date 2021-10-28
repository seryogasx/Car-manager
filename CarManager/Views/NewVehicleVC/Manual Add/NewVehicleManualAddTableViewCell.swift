//
//  NewVehicleManualAddTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 28.10.2021.
//

import UIKit

class NewVehicleManualAddTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        submitButton.isHidden = true
        textField.isHidden = false
        headerLabel.isHidden = false
    }
    
    func setup(header: String, placeholder: String) {
        if header != "Добавить авто" {
            headerLabel.text = header
            textField.placeholder = placeholder
            stackView.alignment = .fill
        } else {
            headerLabel.isHidden = true
            textField.isHidden = true
            
            submitButton.isHidden = false
            submitButton.titleLabel?.textColor = .white
            submitButton.backgroundColor = .blue
            submitButton.layer.cornerRadius = 20
            submitButton.titleLabel?.text = header
            
            stackView.alignment = .center
        }
    }
}

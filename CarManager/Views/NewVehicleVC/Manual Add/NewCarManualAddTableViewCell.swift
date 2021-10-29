//
//  NewVehicleManualAddTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 28.10.2021.
//

import UIKit

protocol NewCarManualAddDelegate: AnyObject {
    func updateInfo(key: String, value: String)
    func confirmChanges()
}

class NewCarManualAddTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    weak var delegate: NewCarManualAddDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = ""
        submitButton.titleLabel?.text = "Добавить авто"
        submitButton.titleLabel?.textColor = .white
    }
    
    func setup(header: String, placeholder: String, text: String?, delegate: NewCarManualAddDelegate) {
        self.delegate = delegate
        if header != "Добавить авто" {
            headerLabel.isHidden = false
            textField.isHidden = false
            submitButton.isHidden = true
            
            headerLabel.text = header
            stackView.alignment = .fill
            
            textField.placeholder = placeholder
            if let text = text {
                textField.text = text
            }
            
            textField.addTarget(self, action: #selector(textHasBeenChanged), for: .editingChanged)
        } else {
            headerLabel.isHidden = true
            textField.isHidden = true
            submitButton.isHidden = false

            submitButton.titleLabel?.textColor = .white
            submitButton.layer.cornerRadius = 2
            submitButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
            
            stackView.alignment = .center
            
        }
    }
    
    @objc func textHasBeenChanged() {
        self.delegate?.updateInfo(key: headerLabel.text!, value: textField.text!)
    }
    
    @objc func confirmButtonPressed() {
        delegate?.confirmChanges()
    }
}

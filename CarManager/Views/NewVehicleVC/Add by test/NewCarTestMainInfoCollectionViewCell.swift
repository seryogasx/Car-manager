//
//  NewCarTestMainInfoCollectionViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 18.11.2021.
//

import UIKit

class NewCarTestMainInfoCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var markTextField: UITextField!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var mileageTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    weak var delegate: NewCarAddDelegate?
    var properties: [String] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(properties: [String], delegate: NewCarAddDelegate) {
        self.delegate = delegate
        self.properties = properties
        
        titleLabel.text = "О новой машине"
        markLabel.text = "Какая марка?"
        markTextField.placeholder = "Mercedes, Skoda и др."
        modelLabel.text = "Какая модель?"
        modelTextField.placeholder = "Golf, Corolla и др."
        yearLabel.text = "Какого года?"
        yearTextField.placeholder = "Одно число (например, 2020)"
        mileageLabel.text = "Какой пробег?"
        mileageTextField.placeholder = "Одно число (например, 10000)"
        
        nextButton.setTitle("Далее", for: .normal)
    }
}

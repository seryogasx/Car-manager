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
        
        titleLabel.attributedText = AppFonts.mainTitle(string: "О новой машине")
        
        markLabel.text = Car.getHintForProperty(property: "mark")
        markTextField.placeholder = "Mercedes, Skoda и др."
        markTextField.addTarget(self, action: #selector(markHasBeenChanged), for: .editingChanged)
        
        modelLabel.text = Car.getHintForProperty(property: "model")
        modelTextField.placeholder = "Golf, Corolla и др."
        modelTextField.addTarget(self, action: #selector(modelHasBeenChanged), for: .editingChanged)
        
        yearLabel.text = Car.getHintForProperty(property: "year")
        yearTextField.placeholder = "Одно число (например, 2020)"
        yearTextField.addTarget(self, action: #selector(yearHasBeenChanged), for: .editingChanged)
        
        mileageLabel.text = Car.getHintForProperty(property: "mileage")
        mileageTextField.placeholder = "Одно число (например, 10000)"
        mileageTextField.addTarget(self, action: #selector(mileageHasBeenChanged), for: .editingChanged)
        
        nextButton.setTitle("Далее", for: .normal)
    }
    
    @objc private func markHasBeenChanged() {
        delegate?.updateInfo(key: "mark", value: markTextField.text ?? "")
    }
    
    @objc private func modelHasBeenChanged() {
        delegate?.updateInfo(key: "model", value: modelTextField.text ?? "")
    }
    
    @objc private func yearHasBeenChanged() {
        delegate?.updateInfo(key: "year", value: yearTextField.text ?? "")
    }
    
    @objc private func mileageHasBeenChanged() {
        delegate?.updateInfo(key: "mileage", value: mileageTextField.text ?? "")
    }
}

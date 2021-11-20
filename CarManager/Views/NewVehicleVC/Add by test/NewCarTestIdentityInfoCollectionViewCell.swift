//
//  NewCarTestIdentityInfoCollectionViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 18.11.2021.
//

import UIKit

class NewCarTestIdentityInfoCollectionViewCell: UICollectionViewCell, ReuseIdentifying {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var carNickNameLabel: UILabel!
    @IBOutlet weak var carNickNameTextField: UITextField!
    @IBOutlet weak var carPhotoLabel: UILabel!
    @IBOutlet weak var carPhotoImageView: UIImageView!
    @IBOutlet weak var nextPageButton: UIButton!
    
    weak var delegate: NewCarAddDelegate?
    
    var properties: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        carPhotoImageView.image = UIImage(named: "DefaultCarImage")
        carPhotoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoHasBeenPressed)))
        carNickNameTextField.addTarget(self, action: #selector(dataHasBeenChanged(sender:)), for: .editingChanged)
    }
    
    func setup(properties: [String], delegate: NewCarAddDelegate) {
        titleLabel.text = "Добавим новое авто!"
        carNickNameLabel.text = "Как назовем авто?"
        carPhotoLabel.text = "Добавим фото?"
        nextPageButton.setTitle("Далее", for: .normal)
        
        self.delegate = delegate
        self.properties = properties
    }

    @objc func photoHasBeenPressed() {
        delegate?.photoHasBeenPressed()
    }
    
    @objc func dataHasBeenChanged(sender: Any) {
        if let textField = sender as? UITextField {
            self.delegate?.updateInfo(key: "nickName", value: textField.text!)
        }
    }
}

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
    }
    
    func setup(properties: [String], delegate: NewCarAddDelegate, textFieldText: String?, image: UIImage?) {
        titleLabel.attributedText = NSAttributedString(string: "")//AppFonts.mainTitle(string: "Добавим новое авто!")
        carNickNameLabel.text = "Как назовем авто?"
        carPhotoLabel.text = "Добавим фото?"
        nextPageButton.setTitle("Далее", for: .normal)
        carNickNameTextField.text = textFieldText
        
        carPhotoImageView.contentMode = .scaleToFill
        carPhotoImageView.layer.cornerRadius = carPhotoImageView.frame.height / 5
        carPhotoImageView.isUserInteractionEnabled = true
        carPhotoImageView.image = image ?? UIImage(named: "DefaultCarImage")
        carPhotoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoHasBeenPressed)))
        carNickNameTextField.addTarget(self, action: #selector(dataHasBeenChanged(sender:)), for: .editingChanged)
        
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

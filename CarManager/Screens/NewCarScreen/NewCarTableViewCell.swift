//
//  NewCarTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 13.05.2022.
//

import UIKit
import RxSwift

enum VisibleCellType {
    case carLogo
    case carInfo
    case carAdd
}

class NewCarTableViewCell: UITableViewCell, ReuseIdentifying {
    
    var cellType: VisibleCellType = .carLogo
    var carLogoImage: PublishSubject<UIImage>?
    weak var viewController: NewCarViewControllerProtocol? {
        didSet {
            self.imagePicker = ImagePicker(presentationController: viewController!, delegate: self)
        }
    }
    var imagePicker: ImagePicker?
    
    var carImageView: CircularImageView = {
        let carImageView = CircularImageView()
//        carImageView.image = UIImage(named: "DefaultCarImage")
        carImageView.contentMode = .scaleAspectFill
        carImageView.isUserInteractionEnabled = true
        carImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                 action: #selector(presentImagePicker(sender:))))
        carImageView.backgroundColor = .blue
        carImageView.becomeFirstResponder()
        return carImageView
    }()
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    var addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 3
        button.setTitle(" Добавить авто ", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.sizeToFit()
        return button
    }()
    
    @objc private func presentImagePicker(sender: UITapGestureRecognizer) {
//        self.imagePicker?.present(from: self)
        print("kek")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("selected")
        // Configure the view for the selected state
    }
    
    func update(cellType: VisibleCellType, image: UIImage?, text: String?) {
        self.cellType = cellType
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        switch cellType {
            case .carLogo:
                self.addSubview(carImageView)
                carImageView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(10)
                    make.bottom.equalToSuperview().offset(-10)
                    make.centerX.equalToSuperview()
                    make.height.equalTo(150)
                    make.width.equalTo(carImageView.snp.height)
                }
            case .carInfo:
                self.addSubview(textField)
                textField.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(10)
                    make.bottom.equalToSuperview().offset(-10)
                    make.leading.equalToSuperview().offset(10)
                    make.width.equalTo(200)
                    make.height.equalTo(30)
                }
            case .carAdd:
                self.addSubview(addButton)
                addButton.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(10)
                    make.bottom.equalToSuperview().offset(-10)
                    make.height.equalTo(50)
                    make.centerX.equalToSuperview()
                }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.carImageView.removeFromSuperview()
        self.textField.removeFromSuperview()
        self.addButton.removeFromSuperview()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewCarTableViewCell: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let _ = self.carLogoImage, let image = image {
            self.carLogoImage!.onNext(image)
        }
    }
}

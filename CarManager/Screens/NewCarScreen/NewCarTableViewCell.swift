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
    
    lazy var carImageView: CircularImageView = {
        let carImageView = CircularImageView()
        carImageView.image = UIImage(named: "DefaultCarImage")
        carImageView.contentMode = .scaleAspectFill
        carImageView.isUserInteractionEnabled = true
        return carImageView
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 3
        button.setTitle(" Добавить авто ", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.sizeToFit()
        return button
    }()
    
    lazy var attributeLabel: UILabel = {
        let attributeLabel = UILabel()
        return attributeLabel
    }()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @objc private func presentImagePicker(sender: UITapGestureRecognizer) {
        self.imagePicker?.present(from: self)
//        print("kek")
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
    
    func update(attributeText: String?, cellType: VisibleCellType, image: UIImage?, text: String?, placeholder: String?) {
        self.cellType = cellType
        if let attributeText = attributeText {
            self.attributeLabel.text = attributeText
            self.attributeLabel.sizeToFit()
        }
        if let image = image {
            self.carImageView.image = image
            self.carLogoImage?.onNext(image)
        }
        if let text = text, !text.isEmpty {
            self.textField.text = text
        }
        if let placeholder = placeholder {
            self.textField.placeholder = placeholder
        }
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
                self.addSubview(attributeLabel)
                attributeLabel.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(10)
                    make.leading.equalToSuperview().offset(10)
                    make.height.equalTo(20)
                }
                self.addSubview(textField)
                textField.snp.makeConstraints { make in
                    make.top.equalTo(attributeLabel.snp.bottom).offset(5)
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
        self.attributeLabel.removeFromSuperview()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        carImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                 action: #selector(presentImagePicker(sender:))))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewCarTableViewCell: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let image = image {
            self.carImageView.image = image
            self.carLogoImage?.onNext(image)
        }
    }
}

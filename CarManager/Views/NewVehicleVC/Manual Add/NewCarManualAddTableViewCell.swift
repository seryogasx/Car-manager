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
    func photoHasBeenPressed()
}

class NewCarManualAddTableViewCell: UITableViewCell, ReuseIdentifying {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var boolSwitch: UISwitch!
    @IBOutlet weak var carImageView: UIImageView!
    
    weak var delegate: NewCarManualAddDelegate?
    
    var propertyName = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = ""
        headerLabel.text = ""
        submitButton.titleLabel?.text = ""
        submitButton.titleLabel?.textColor = .white
    }
    
    func setup(type: NewCarContentType, header: String?, text: String?, delegate: NewCarManualAddDelegate, image: UIImage? = nil) {
        self.delegate = delegate
        self.propertyName = header ?? ""
        switch type {
            case .photo:
                boolSwitch.isHidden = true
                headerLabel.isHidden = true
                textField.isHidden = true
                textField.text = "Photo"
                submitButton.isHidden = true
                boolSwitch.isHidden = true
                
                carImageView.isHidden = false
                carImageView.setCarImage(image: image)
                carImageView.isUserInteractionEnabled = true
                carImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoHasBeenPressed)))
            case .input:
                let labelHintText = getHintText(header!)
                headerLabel.isHidden = false
                textField.isHidden = false
                submitButton.isHidden = true
                boolSwitch.isHidden = true
                carImageView.isHidden = true
                
                headerLabel.text = labelHintText
                if let text = text {
                    textField.text = text
                }
                
                textField.addTarget(self, action: #selector(dataHasBeenChanged(sender:)), for: .editingChanged)
            case .select:
                let labelHintText = getHintText(header!)
                headerLabel.isHidden = false
                textField.isHidden = false
                submitButton.isHidden = true
                boolSwitch.isHidden = true
                carImageView.isHidden = true
                
                headerLabel.text = labelHintText
                if let text = text {
                    textField.text = text
                }
                
                textField.addTarget(self, action: #selector(dataHasBeenChanged(sender:)), for: .editingChanged)
            case .bool:
                let labelHintText = getHintText(header!)
                headerLabel.isHidden = false
                headerLabel.text = labelHintText
                
                textField.isHidden = true
                submitButton.isHidden = true
                boolSwitch.isHidden = false
                carImageView.isHidden = true
                
                boolSwitch.addTarget(self, action: #selector(dataHasBeenChanged(sender:)), for: .valueChanged)
                boolSwitch.setOn(false, animated: false)
            case .confirm:
                headerLabel.isHidden = true
                textField.isHidden = true
                submitButton.isHidden = false
                boolSwitch.isHidden = true
                carImageView.isHidden = true

                submitButton.titleLabel?.textColor = .white
                submitButton.layer.cornerRadius = 2
                submitButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        }
    }
    
    @objc func dataHasBeenChanged(sender: Any) {
        if let textField = sender as? UITextField {
            self.delegate?.updateInfo(key: propertyName, value: textField.text!)
        } else if let switcher = sender as? UISwitch {
            self.delegate?.updateInfo(key: propertyName, value: String(switcher.isOn))
        }
    }
    
    @objc func confirmButtonPressed() {
        delegate?.confirmChanges()
    }
    
    @objc private func photoHasBeenPressed() {
        delegate?.photoHasBeenPressed()
    }
    
    private func getHintText(_ header: String) -> String {
        switch header {
            case "nickName":
                return "Псевдоним"
            case "mark":
                return "Марка авто"
            case "model":
                return "Модель авто"
            case "year":
                return "Год выпуска"
            case "photo":
                return "Добавить фото"
            case "mileage":
                return "Текущий пробег"
            case "engineType":
                return "Тип двигателя"
            case "transmissionType":
                return "Тип трансмиссии"
            case "wheelsSize":
                return "Размер дисков"
            case "tireType":
                return "Тип резины"
            case "antifreezeAge":
                return "Последняя замена антифриза"
            case "brakeFluidAge":
                return "Последняя замена тормозной жидкости"
            case "aidKitAge":
                return "Возраст аптечки"
            case "reflectiveVestExists":
                return "Светоотражающий жилет"
            case "warningTriangleExists":
                return "Знак аварийной остановки"
            case "scraperExists":
                return "Скребок от льда"
            case "brainageBasinExists":
                return "Водосгон"
            case "compressorExists":
                return "Компрессор"
            case "startingWiresExists":
                return "Пусковые провода"
            case "ragsExists":
                return "Тряпочки для сушки"
            case "videoRecorderExists":
                return "Видеорегистратор"
            case "fusesExists":
                return "Запасные предохранители"
            case "spareWheelExists":
                return "Запасное колесо"
            case "jackExists":
                return "Домкрат"
            case "spannersExists":
                return "Инструменты"
            case "extinguisherAge":
                return "Возраст огнетушителя"
            default:
                return "UNKNOWN"
        }
    }
}

extension UIImageView {
    func setCarImage(image: UIImage?) {
        self.image = image ?? UIImage(named: "DefaultCarImage")
    }
}

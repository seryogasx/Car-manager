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
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var boolSwitch: UISwitch!
    
    weak var delegate: NewCarManualAddDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = ""
        headerLabel.text = ""
        submitButton.titleLabel?.text = ""
        submitButton.titleLabel?.textColor = .white
    }
    
    func setup(type: NewCarContentType, header: String?, text: String?, delegate: NewCarManualAddDelegate) {
        self.delegate = delegate
        
        switch type {
            case .photo:
                boolSwitch.isHidden = true
                headerLabel.isHidden = true
                textField.isHidden = false
                textField.text = "Photo"
                submitButton.isHidden = true
                boolSwitch.isHidden = true
            case .input:
                let labelHintText = getHintText(header!)
                headerLabel.isHidden = false
                textField.isHidden = false
                submitButton.isHidden = true
                boolSwitch.isHidden = true
                
                headerLabel.text = labelHintText
                if let text = text {
                    textField.text = text
                }
                
                textField.addTarget(self, action: #selector(textHasBeenChanged), for: .editingChanged)
            case .select:
                let labelHintText = getHintText(header!)
                headerLabel.isHidden = false
                textField.isHidden = false
                submitButton.isHidden = true
                boolSwitch.isHidden = true
                
                headerLabel.text = labelHintText
                if let text = text {
                    textField.text = text
                }
                
                textField.addTarget(self, action: #selector(textHasBeenChanged), for: .editingChanged)
            case .bool:
                let labelHintText = getHintText(header!)
                headerLabel.isHidden = false
                headerLabel.text = labelHintText
                
                textField.isHidden = true
                submitButton.isHidden = true
                boolSwitch.isHidden = false
            case .confirm:
                headerLabel.isHidden = true
                textField.isHidden = true
                submitButton.isHidden = false
                boolSwitch.isHidden = true

                submitButton.titleLabel?.textColor = .white
                submitButton.layer.cornerRadius = 2
                submitButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)

        }
    }
    
    @objc func textHasBeenChanged() {
        self.delegate?.updateInfo(key: headerLabel.text!, value: textField.text!)
    }
    
    @objc func confirmButtonPressed() {
        delegate?.confirmChanges()
    }
    
    private func getHintText(_ header: String) -> String {
        switch header {
            case "nickName":
                return "Введите псевдоним"
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
                return "Замена антифриза?"
            case "brakeFluidAge":
                return "Замена тормозной жидкости?"
            case "aidKitAge":
                return "Сколько лет аптечке?"
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
                return "Сколько лет огнетушителю?"
            default:
                return "UNKNOWN"
        }
    }
}

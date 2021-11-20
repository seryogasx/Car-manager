//
//  NewCarTestAdditionalInfoCollectionViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 18.11.2021.
//

import UIKit
import SnapKit

class NewCarTestAdditionalInfoCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    var labels: [UILabel] = []
    var textFields: [UITextField] = []
    var switchers: [UISwitch] = []
    let finishButton = UIButton()
    let titleLabel = UILabel()
    var offsettedView: UIView!
    
    weak var delegate: NewCarAddDelegate?
    
    var additionalProperties = Array<String>()
    var boolProperties = Array<String>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(additionalProperties: [String], boolProperties: [String], delegate: NewCarAddDelegate) {
        self.delegate = delegate
        self.additionalProperties = additionalProperties
        self.boolProperties = boolProperties
        createLayout()
    }
    
    private func createLayout() {
        initTitleLabel()
        createAdditionalPropertiesUI()
        createBoolPropertiesUI()
        initFinishButton()
    }
    
    private func initTitleLabel() {
        infoView.addSubview(titleLabel)
        titleLabel.text = "Добавим детали"
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        offsettedView = titleLabel
    }
    
    private func createAdditionalPropertiesUI() {
        additionalProperties.forEach { propertyName in
            let newPropertyLabel = UILabel()
            labels.append(newPropertyLabel)
            infoView.addSubview(newPropertyLabel)
            newPropertyLabel.text = propertyName
            newPropertyLabel.snp.makeConstraints { make in
                if offsettedView == titleLabel {
                    make.top.equalTo(offsettedView.snp.bottom).offset(20)
                } else {
                    make.top.equalTo(offsettedView.snp.bottom).offset(10)
                }
                make.leading.equalToSuperview().offset(15)
                make.height.equalTo(30)
                offsettedView = newPropertyLabel
            }
            
            let newPropertyTextField = UITextField()
            textFields.append(newPropertyTextField)
            infoView.addSubview(newPropertyTextField)
            newPropertyTextField.placeholder = "Выберете из списка"
            newPropertyTextField.snp.makeConstraints { make in
                make.top.equalTo(offsettedView.snp.bottom).offset(10)
                make.leading.equalToSuperview().offset(15)
                make.width.equalTo(UIScreen.main.bounds.width / 2 + 15)
                make.height.equalTo(30)
                offsettedView = newPropertyTextField
            }
        }
    }
    
    private func createBoolPropertiesUI() {
        boolProperties.forEach { propertyName in
            let newPropertyLabel = UILabel()
            labels.append(newPropertyLabel)
            infoView.addSubview(newPropertyLabel)
            newPropertyLabel.text = propertyName
            newPropertyLabel.snp.makeConstraints { make in
//                if offsettedView == titleLabel {
//                    make.top.equalTo(offsettedView).offset(20)
//                } else {
                make.top.equalTo(offsettedView.snp.bottom).offset(10)
//                }
                make.leading.equalToSuperview().offset(15)
                make.height.equalTo(30)
                offsettedView = newPropertyLabel
            }
            
            let newPropertySwitcher = UISwitch()
            switchers.append(newPropertySwitcher)
            infoView.addSubview(newPropertySwitcher)
            newPropertySwitcher.snp.makeConstraints { make in
                make.centerY.equalTo(offsettedView)
                make.trailing.equalToSuperview().offset(-15)
                offsettedView = newPropertySwitcher
            }
        }
    }
    
    private func initFinishButton() {
        infoView.addSubview(finishButton)
        finishButton.setTitle("Добавить авто", for: .normal)
        finishButton.setTitleColor(.systemBlue, for: .normal)
        finishButton.snp.makeConstraints { make in
            make.top.equalTo(offsettedView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
        
        finishButton.addTarget(self, action: #selector(finishButtonPressed), for: .touchUpInside)
    }
    
    @objc private func finishButtonPressed() {
        delegate?.confirmChanges()
    }
}

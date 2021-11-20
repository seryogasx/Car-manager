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
//    var labels: [UILabel] = []
//    var textFields: [UITextField] = []
//    var switchers: [UISwitch] = []
    let finishButton = UIButton()
    let titleLabel = UILabel()
//    let additionalTitleLabel = UILabel()
    let boolTitleLabel = UILabel()
    var offsettedView: UIView!
    
    let mainXConstraint: CGFloat = 10
    let secondaryXConstraint: CGFloat = 15
    let mainYConstraint: CGFloat = 30
    let secondaryYConstraint: CGFloat = 10
    
    let secondaryLabelHeight: CGFloat = 30
    let textFieldHeight: CGFloat = 30
    
    weak var delegate: NewCarAddDelegate?
    
    var additionalProperties = Array<String>()
    var additionalPropertiesValues = Array<String>()
    var boolProperties = Array<String>()
    var boolPropertiesValues = Array<Bool>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(additionalProperties: [String], additionalPropertiesValues: [String], boolProperties: [String], boolPropertiesValues: [Bool], delegate: NewCarAddDelegate) {
        self.delegate = delegate
        self.additionalProperties = additionalProperties
        self.additionalPropertiesValues = additionalPropertiesValues
        self.boolProperties = boolProperties
        createLayout()
    }
    
    private func createLayout() {
        initTitleLabel()
        createAdditionalPropertiesUI()
        infoView.addSubview(boolTitleLabel)
        boolTitleLabel.attributedText = AppFonts.secondaryTitle(string: "Дополнительное оборудование")
        boolTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(offsettedView.snp.bottom).offset(mainYConstraint)
            make.leading.equalToSuperview().offset(secondaryXConstraint)
        }
        offsettedView = boolTitleLabel
        
        createBoolPropertiesUI()
        initFinishButton()
    }
    
    private func initTitleLabel() {
        infoView.addSubview(titleLabel)
        titleLabel.attributedText = AppFonts.mainTitle(string: "Добавим детали")
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        offsettedView = titleLabel
    }
    
    private func createAdditionalPropertiesUI() {
        additionalProperties.enumerated().forEach { (index, propertyName) in
            let newPropertyLabel = UILabel()
//            labels.append(newPropertyLabel)
            infoView.addSubview(newPropertyLabel)
            newPropertyLabel.text = Car.getHintForProperty(property: propertyName)
            newPropertyLabel.snp.makeConstraints { make in
                if offsettedView == titleLabel {
                    make.top.equalTo(offsettedView.snp.bottom).offset(mainYConstraint)
                } else {
                    make.top.equalTo(offsettedView.snp.bottom).offset(secondaryYConstraint)
                }
                make.leading.equalToSuperview().offset(secondaryXConstraint)
                make.height.equalTo(secondaryLabelHeight)
                offsettedView = newPropertyLabel
            }
            newPropertyLabel.tag = index
            
            let newPropertyTextField = UITextField()
//            newPropertyTextField.isUserInteractionEnabled = false
//            textFields.append(newPropertyTextField)
            infoView.addSubview(newPropertyTextField)

            newPropertyTextField.placeholder = "Выберете из списка"
            newPropertyTextField.snp.makeConstraints { make in
                make.top.equalTo(offsettedView.snp.bottom).offset(secondaryYConstraint)
                make.leading.equalToSuperview().offset(secondaryXConstraint)
                make.width.equalTo(UIScreen.main.bounds.width / 2 + secondaryXConstraint)
                make.height.equalTo(textFieldHeight)
            }
            newPropertyTextField.tag = index
            newPropertyTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(propertyLabelTapped(sender:))))
            offsettedView = newPropertyTextField
        }
    }
    
    @objc private func propertyLabelTapped(sender: UITapGestureRecognizer) {
        if let selectorView = sender.view {
            let newPosition = CGPoint(x: 0.0, y: selectorView.frame.origin.y - selectorView.frame.height - secondaryYConstraint)
            scrollView.setContentOffset(newPosition, animated: true)
            delegate?.showOverlay(baseFrame: CGRect(x: newPosition.x + secondaryXConstraint, y: secondaryLabelHeight + secondaryYConstraint + textFieldHeight, width: selectorView.frame.width, height: selectorView.frame.height), propertyName: additionalProperties[selectorView.tag])
        }
    }
    
    private func createBoolPropertiesUI() {
        boolProperties.forEach { propertyName in
            let newPropertyLabel = UILabel()
//            labels.append(newPropertyLabel)
            infoView.addSubview(newPropertyLabel)
            newPropertyLabel.text = Car.getHintForProperty(property: propertyName)
            newPropertyLabel.snp.makeConstraints { make in
                make.top.equalTo(offsettedView.snp.bottom).offset(secondaryYConstraint)
                make.leading.equalToSuperview().offset(secondaryXConstraint)
                make.height.equalTo(secondaryLabelHeight)
                offsettedView = newPropertyLabel
            }
            
            let newPropertySwitcher = UISwitch()
//            switchers.append(newPropertySwitcher)
            infoView.addSubview(newPropertySwitcher)
            newPropertySwitcher.snp.makeConstraints { make in
                make.centerY.equalTo(offsettedView)
                make.trailing.equalToSuperview().offset(-secondaryXConstraint)
                offsettedView = newPropertySwitcher
            }
        }
    }
    
    private func initFinishButton() {
        infoView.addSubview(finishButton)
        finishButton.setTitle("Добавить авто", for: .normal)
        finishButton.setTitleColor(.systemBlue, for: .normal)
        finishButton.snp.makeConstraints { make in
            make.top.equalTo(offsettedView.snp.bottom).offset(mainYConstraint)
            make.bottom.equalToSuperview().offset(-mainYConstraint)
            make.centerX.equalToSuperview()
        }
        
        finishButton.addTarget(self, action: #selector(finishButtonPressed), for: .touchUpInside)
    }
    
    @objc private func finishButtonPressed() {
        delegate?.confirmChanges()
    }
}

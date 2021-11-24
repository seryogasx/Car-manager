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
    let finishButton = UIButton()
    let titleLabel = UILabel()
    let boolTitleLabel = UILabel()
    var offsettedView: UIView!
    
    let mainXConstraint: CGFloat = 10
    let secondaryXConstraint: CGFloat = 15
    let mainYConstraint: CGFloat = 30
    let secondaryYConstraint: CGFloat = 10
    
    let secondaryLabelHeight: CGFloat = 30
    let selectedViewHeight: CGFloat = 40
    
    weak var delegate: NewCarAddDelegate?
    
    var additionalProperties = Array<String>()
    var additionalPropertiesValues = Array<String?>()
    var boolProperties = Array<String>()
    var boolPropertiesValues = Array<String?>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(additionalProperties: [String], additionalPropertiesValues: [String?], boolProperties: [String], boolPropertiesValues: [String?], delegate: NewCarAddDelegate) {
        self.delegate = delegate
        self.additionalProperties = additionalProperties
        self.additionalPropertiesValues = additionalPropertiesValues
        self.boolProperties = boolProperties
        self.boolPropertiesValues = boolPropertiesValues
        createLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.infoView.subviews.forEach { $0.removeFromSuperview() }
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
            
            if index == 1 || index == 2 {
                let options = Car.getOptionsForProperty(propertyName: propertyName)
                let newPropertySegmentControl = UISegmentedControl(items: options)
                infoView.addSubview(newPropertySegmentControl)
                newPropertySegmentControl.snp.makeConstraints { make in
                    make.height.equalTo(selectedViewHeight)
                    make.top.equalTo(offsettedView.snp.bottom).offset(secondaryYConstraint)
                    make.leading.equalToSuperview().offset(secondaryXConstraint)
                }
                if let value = additionalPropertiesValues[index] {
                    newPropertySegmentControl.selectedSegmentIndex = options.firstIndex(of: value)!
                }
                newPropertySegmentControl.addTarget(self, action: #selector(segmentHasChanged(sender:)), for: .valueChanged)
                newPropertySegmentControl.tag = index
                offsettedView = newPropertySegmentControl
            } else if index == 3 {
                let options = Car.getOptionsForProperty(propertyName: propertyName)
                let newPropertySlider = UISlider()
                infoView.addSubview(newPropertySlider)
                let minimum = (options.first! as NSString).floatValue
                let maximum = (options.last! as NSString).floatValue
                newPropertySlider.minimumValue = minimum
                newPropertySlider.maximumValue = maximum
                if let value = additionalPropertiesValues[index] {
                    newPropertySlider.setValue((value as NSString).floatValue, animated: false)
                }
                newPropertySlider.snp.makeConstraints { make in
                    make.top.equalTo(offsettedView.snp.bottom).offset(secondaryYConstraint)
                    make.leading.equalToSuperview().offset(secondaryXConstraint * 3)
                    make.trailing.equalToSuperview().offset(-secondaryXConstraint * 3)
                    make.height.equalTo(selectedViewHeight)
                }
                newPropertySlider.tag = index
                newPropertySlider.isContinuous = false
                newPropertySlider.addTarget(self, action: #selector(sliderHasChanged(sender:)), for: .valueChanged)
                offsettedView = newPropertySlider
            }
            else {
                let newPropertyTextField = UITextField()
                infoView.addSubview(newPropertyTextField)
                if let value = additionalPropertiesValues[index] {
                    newPropertyTextField.text = value
                } else {
                    newPropertyTextField.placeholder = "Выберете из списка"
                }
                newPropertyTextField.snp.makeConstraints { make in
                    make.top.equalTo(offsettedView.snp.bottom).offset(secondaryYConstraint)
                    make.leading.equalToSuperview().offset(secondaryXConstraint)
                    make.width.equalTo(UIScreen.main.bounds.width / 2 + secondaryXConstraint)
                    make.height.equalTo(selectedViewHeight)
                }
                newPropertyTextField.tag = index
                newPropertyTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(propertyTextFieldTapped(sender:))))
                offsettedView = newPropertyTextField
            }
        }
    }
    
    @objc private func sliderHasChanged(sender: UISlider) {
        let roundedValue = sender.value.rounded(.down)
        sender.setValue(roundedValue, animated: true)
        delegate?.updateInfo(key: additionalProperties[sender.tag], value: Int16(roundedValue))
    }
    
    @objc private func segmentHasChanged(sender: UISegmentedControl) {
        let propertyName = additionalProperties[sender.tag]
        delegate?.updateInfo(key: propertyName, value: Car.getOptionsForProperty(propertyName: propertyName)[sender.selectedSegmentIndex])
    }
    
    @objc private func propertyTextFieldTapped(sender: UITapGestureRecognizer) {
        if let selectorView = sender.view {
            let newPosition = CGPoint(x: 0.0, y: selectorView.frame.origin.y - selectorView.frame.height - secondaryYConstraint)
            scrollView.setContentOffset(newPosition, animated: true)
            delegate?.showOverlay(overlayView: selectorView, propertyName: additionalProperties[selectorView.tag])
        }
    }
    
    private func createBoolPropertiesUI() {
        boolProperties.enumerated().forEach { index, propertyName in
            let newPropertyLabel = UILabel()
            infoView.addSubview(newPropertyLabel)
            newPropertyLabel.text = Car.getHintForProperty(property: propertyName)
            newPropertyLabel.snp.makeConstraints { make in
                make.top.equalTo(offsettedView.snp.bottom).offset(secondaryYConstraint)
                make.leading.equalToSuperview().offset(secondaryXConstraint)
                make.height.equalTo(secondaryLabelHeight)
            }
            offsettedView = newPropertyLabel
            
            let newPropertySwitcher = UISwitch()
            infoView.addSubview(newPropertySwitcher)
            newPropertySwitcher.snp.makeConstraints { make in
                make.centerY.equalTo(offsettedView)
                make.trailing.equalToSuperview().offset(-secondaryXConstraint)
            }
            newPropertySwitcher.tag = index
            newPropertySwitcher.isOn = boolPropertiesValues[index] == "true"
            offsettedView = newPropertySwitcher
            newPropertySwitcher.addTarget(self, action: #selector(switcherHasBeenTapped(sender:)), for: .valueChanged)
        }
    }
    
    @objc private func switcherHasBeenTapped(sender: UISwitch) {
        delegate?.updateInfo(key: boolProperties[sender.tag], value: sender.isOn)
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

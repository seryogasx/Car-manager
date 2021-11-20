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
    let textFieldHeight: CGFloat = 30
    let tableCellHeight: CGFloat = 50
    
    weak var delegate: NewCarAddDelegate?
    
    var additionalProperties = Array<String>()
    var boolProperties = Array<String>()
    
    var selectedOptions: [String] = []
    var currentPropertyNameSetting: String?
    var currentPropertyTextFieldSetting: UITextField?
    let overlayView = UIView()
    let tableView = UITableView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(additionalProperties: [String], boolProperties: [String], delegate: NewCarAddDelegate) {
        self.delegate = delegate
        self.additionalProperties = additionalProperties
        self.boolProperties = boolProperties
        createLayout()
        setupOverlayView()
    }
    
    private func setupOverlayView() {
        overlayView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        overlayView.backgroundColor = UIColor.black
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeTransparentView)))
        overlayView.alpha = 0
        self.contentView.addSubview(overlayView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.contentView.addSubview(tableView)
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
            
            let newPropertyTextField = UITextField()
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
            print(selectorView.frame)
            print(selectorView.bounds)
            let newPosition = CGPoint(x: 0.0, y: selectorView.frame.origin.y - selectorView.frame.height - secondaryYConstraint)
            scrollView.setContentOffset(newPosition, animated: true)
            currentPropertyTextFieldSetting = selectorView as? UITextField
            showOverlay(baseFrame: CGRect(x: newPosition.x + secondaryXConstraint, y: secondaryLabelHeight + secondaryYConstraint, width: selectorView.frame.width, height: selectorView.frame.height), propertyName: additionalProperties[selectorView.tag])
        }
    }
    
    private func createBoolPropertiesUI() {
        boolProperties.forEach { propertyName in
            let newPropertyLabel = UILabel()
            infoView.addSubview(newPropertyLabel)
            newPropertyLabel.text = Car.getHintForProperty(property: propertyName)
            newPropertyLabel.snp.makeConstraints { make in
                make.top.equalTo(offsettedView.snp.bottom).offset(secondaryYConstraint)
                make.leading.equalToSuperview().offset(secondaryXConstraint)
                make.height.equalTo(secondaryLabelHeight)
                offsettedView = newPropertyLabel
            }
            
            let newPropertySwitcher = UISwitch()
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

extension NewCarTestAdditionalInfoCollectionViewCell {
    
    private func getOptionsForProperty(propertyName: String) -> [String] {
        return ["kek", "cheburek"]
    }
    func showOverlay(baseFrame: CGRect, propertyName: String) {
        selectedOptions = getOptionsForProperty(propertyName: propertyName)
        guard selectedOptions.count > 0 else { return }
        currentPropertyNameSetting = propertyName

        currentPropertyTextFieldSetting?.layer.borderWidth = 1
        tableView.frame = CGRect(x: baseFrame.origin.x, y: baseFrame.origin.y + baseFrame.height, width: baseFrame.width, height: 0)
        tableView.layer.borderWidth = 1
        let maxTableViewHeight = min(CGFloat(selectedOptions.count) * self.tableCellHeight, UIScreen.main.bounds.height - (baseFrame.origin.y + baseFrame.height + mainYConstraint))
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveLinear, animations: { [weak self] in
            self?.tableView.frame = CGRect(x: baseFrame.origin.x, y: baseFrame.origin.y + baseFrame.height, width: baseFrame.width, height: maxTableViewHeight)
            self?.tableView.layer.cornerRadius = (self?.tableView.frame.height ?? 0) / 5
            self?.overlayView.alpha = 0.0001
            self?.currentPropertyTextFieldSetting?.layer.borderWidth = 1
            self?.currentPropertyTextFieldSetting?.layer.cornerRadius = (self?.currentPropertyTextFieldSetting?.frame.height ?? 25) / 5
        }, completion: nil)
    }
    
    @objc private func removeTransparentView(baseFrame: CGRect) {
        let tableFrame = tableView.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveLinear
                       , animations: { [weak self] in
            self?.tableView.frame = CGRect(x: tableFrame.origin.x, y: tableFrame.origin.y, width: tableFrame.width, height: 0)
            self?.overlayView.alpha = 0
            self?.currentPropertyTextFieldSetting?.layer.borderWidth = 0
            self?.currentPropertyTextFieldSetting?.layer.cornerRadius = 0
        }, completion: nil)
        currentPropertyNameSetting = nil
        currentPropertyTextFieldSetting = nil
    }
}


extension NewCarTestAdditionalInfoCollectionViewCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.text = selectedOptions[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newOption = selectedOptions[indexPath.item]
        delegate?.updateInfo(key: currentPropertyNameSetting!, value: newOption)
        currentPropertyTextFieldSetting?.placeholder = ""
        currentPropertyTextFieldSetting?.text = newOption
        removeTransparentView(baseFrame: currentPropertyTextFieldSetting!.frame)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewCarTestAdditionalInfoCollectionViewCell: UITableViewDelegate {
    
}

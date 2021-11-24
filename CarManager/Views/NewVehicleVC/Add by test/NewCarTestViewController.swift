//
//  NewVehicleTestViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 27.10.2021.
//

import UIKit

class NewCarTestViewController: UIViewController {

    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataToAdd: [String: Any] = [:]
    var carImage: UIImage?
    
    let identityProperties = Car.getIdentityProperties()
    let mainProperties = Car.getMainProperties()
    let additionalProperties = Car.getAdditionalProperties()
    let boolProperties = Car.getBoolProperties()
    
    var selectedOptions: [String] = []
    var currentPropertyNameSetting: String?
    var currentPropertyTextFieldSetting: UITextField?
    let overlayView = UIView()
    let tableView = UITableView()
    
    let tableCellHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupOverlayView()
    }
    
    private func setupOverlayView() {
        overlayView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        overlayView.backgroundColor = UIColor.black
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeTransparentView)))
        overlayView.alpha = 0
        self.view.addSubview(overlayView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.view.addSubview(tableView)
    }
    
    func setupCollection() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: NewCarTestIdentityInfoCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: NewCarTestIdentityInfoCollectionViewCell.reuseIdentifier)
        collectionView.register(UINib(nibName: NewCarTestMainInfoCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: NewCarTestMainInfoCollectionViewCell.reuseIdentifier)
        collectionView.register(UINib(nibName: NewCarTestAdditionalInfoCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: NewCarTestAdditionalInfoCollectionViewCell.reuseIdentifier)
        collectionView.isPagingEnabled = true
        collectionViewFlowLayout.scrollDirection = .horizontal
    }
}

extension NewCarTestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewCarTestIdentityInfoCollectionViewCell.reuseIdentifier, for: indexPath) as? NewCarTestIdentityInfoCollectionViewCell else {
                    print("wrong cell!")
                    return UICollectionViewCell()
                }
                cell.setup(properties: identityProperties, delegate: self, textFieldText: dataToAdd["nickName"] as? String, image: carImage)
                cell.nextPageButton.addTarget(self, action: #selector(toMainInfo), for: .touchUpInside)
                return cell
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewCarTestMainInfoCollectionViewCell.reuseIdentifier, for: indexPath) as? NewCarTestMainInfoCollectionViewCell else {
                    print("wrong cell!")
                    return UICollectionViewCell()
                }
                cell.setup(properties: mainProperties, delegate: self)
                cell.nextButton.addTarget(self, action: #selector(toAdditionalInfo), for: .touchUpInside)
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewCarTestAdditionalInfoCollectionViewCell.reuseIdentifier, for: indexPath) as? NewCarTestAdditionalInfoCollectionViewCell else {
                    print("wrong cell!")
                    return UICollectionViewCell()
                }
                boolProperties.forEach { property in
                    if dataToAdd[property] == nil {
                        dataToAdd[property] = false
                    }
                }
//                let additionalPropertiesValues = additionalProperties.map { propertyName in
//                    dataToAdd[propertyName] as? String ?? ""
//                }
//                let boolPropertiesValues = boolProperties.map { propertyName in
//                    dataToAdd[propertyName] as! Bool
//                }
//                cell.setup(additionalProperties: additionalProperties, additionalPropertiesValues: additionalPropertiesValues), boolProperties: boolProperties, delegate: self)
                let additionalValues = additionalProperties.map { dataToAdd[$0] == nil ? nil : String(describing: dataToAdd[$0]!) }
                let boolValues = boolProperties.map { dataToAdd[$0] == nil ? nil : String(describing: dataToAdd[$0]!) }
                cell.setup(additionalProperties: additionalProperties, additionalPropertiesValues: additionalValues, boolProperties: boolProperties, boolPropertiesValues: boolValues, delegate: self)
                return cell
        }
    }
    
    
    @objc private func toMainInfo() {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: [.centeredHorizontally, .centeredVertically], animated: true)
    }
    
    @objc private func toAdditionalInfo() {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 2), at: [.centeredVertically, .centeredHorizontally], animated: true)
    }
}

extension NewCarTestViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height - 20
        let width = collectionView.frame.width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension NewCarTestViewController: NewCarAddDelegate {
    func updateInfo(key: String, value: Any) {
        dataToAdd[key] = value
        print(key, dataToAdd[key])
//        if dataToAdd[key] as? String == "" {
        if String(describing: dataToAdd[key]) == "" {
            dataToAdd[key] = nil
        }
    }
    
    func confirmChanges() {
        print(dataToAdd)
        if newCarPropertiesCheck() && StorageManager.shared.saveNewCar(properties: dataToAdd) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func photoHasBeenPressed() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    private func newCarPropertiesCheck() -> Bool {
        guard (dataToAdd["nickName"] != nil) || (dataToAdd["mark"] != nil) || (dataToAdd["model"] != nil) else {
            showAlert(message: "Похоже, что не все данные введены")
            return false
        }
        if let mileageValue = dataToAdd["mileage"] as? String {
            dataToAdd["mileage"] = Int32(mileageValue)
        }
        if let yearValue = dataToAdd["year"] as? String {
            dataToAdd["year"] = Int16(yearValue)
        }
        if !checkImage() {
            if dataToAdd["photoURL"] != nil {
                showAlert(message: "Произошла неизвестная ошибка с картинкой! Попробуйте выбрать её позже в меню авто!")
            }
            dataToAdd["photoURL"] = nil
        }
        return true
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func checkImage() -> Bool {
        if let url = URL(string: dataToAdd["photoURL"] as? String ?? ""),
           let jpegImage = carImage!.jpegData(compressionQuality: 0.8),
           (try? jpegImage.write(to: url)) != nil {
            return true
        }
        return false
    }
    
    func showOverlay(overlayView: UIView, propertyName: String) {
        let baseFrame = overlayView.frame
        selectedOptions = Car.getOptionsForProperty(propertyName: propertyName)
        guard let overlayView = overlayView as? UITextField, selectedOptions.count > 0 else { return }
        currentPropertyNameSetting = propertyName
        currentPropertyTextFieldSetting = overlayView

        currentPropertyTextFieldSetting?.layer.borderWidth = 1
        tableView.frame = CGRect(x: baseFrame.origin.x, y: baseFrame.height, width: baseFrame.width, height: 0)
        tableView.layer.borderWidth = 1
        let maxTableViewHeight = min(CGFloat(selectedOptions.count) * self.tableCellHeight, UIScreen.main.bounds.height - (baseFrame.origin.y + baseFrame.height + 15))
        tableView.reloadData()
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveLinear, animations: { [weak self] in
            self?.tableView.frame = CGRect(x: baseFrame.origin.x, y: baseFrame.origin.y + baseFrame.height, width: baseFrame.width, height: maxTableViewHeight)
            self?.tableView.layer.cornerRadius = 5
            self?.overlayView.alpha = 0.3
            self?.currentPropertyTextFieldSetting?.layer.borderWidth = 1
            self?.currentPropertyTextFieldSetting?.layer.cornerRadius = 5
        }, completion: nil)
    }
    
    @objc private func removeTransparentView(baseFrame: CGRect) {
        let tableFrame = tableView.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveLinear
                       , animations: { [weak self] in
            self?.tableView.frame = CGRect(x: tableFrame.origin.x, y: tableFrame.origin.y, width: tableFrame.width, height: 0)
            self?.currentPropertyTextFieldSetting?.layer.borderWidth = 0
            self?.currentPropertyTextFieldSetting?.layer.cornerRadius = 0
            self?.overlayView.alpha = 0
        }, completion: nil)
        currentPropertyNameSetting = nil
        currentPropertyTextFieldSetting = nil
    }
}

extension NewCarTestViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName).absoluteString
        self.carImage = image
        dataToAdd["photoURL"] = imagePath
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadSections([0])
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension NewCarTestViewController: UITableViewDataSource, UITableViewDelegate {
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
        updateInfo(key: currentPropertyNameSetting!, value: newOption)
        currentPropertyTextFieldSetting?.placeholder = ""
        currentPropertyTextFieldSetting?.text = newOption
        removeTransparentView(baseFrame: currentPropertyTextFieldSetting!.frame)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewCarTestAdditionalInfoCollectionViewCell: UITableViewDelegate {
    
}

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
    
    let overlayView = UIView()
    let tableView = UITableView()
    let cellHeight: CGFloat = 50
    
    let identityProperties = Car.getIdentityProperties()
    let mainProperties = Car.getMainProperties()
    let additionalProperties = Car.getAdditionalProperties()
    let boolProperties = Car.getBoolProperties()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
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
                cell.setup(properties: identityProperties, delegate: self)
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
                cell.setup(additionalProperties: additionalProperties, boolProperties: boolProperties, delegate: self)
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
    func updateInfo(key: String, value: String) {
        dataToAdd[key] = value
        print(dataToAdd[key])
        if dataToAdd[key] as? String == "" {
            dataToAdd[key] = nil
        }
    }
    
    func confirmChanges() {
        if newCarPropertiesCheck() {
            StorageManager.shared.saveNewCar(properties: dataToAdd)
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Не все данные введены", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func photoHasBeenPressed() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    private func newCarPropertiesCheck() -> Bool {
        guard (dataToAdd["nickName"] != nil) || (dataToAdd["mark"] != nil) || (dataToAdd["model"] != nil) else { return false }
        if !checkImage() {
            dataToAdd["photoURL"] = nil
        }
        return true
    }
    
    private func checkImage() -> Bool {
        if let url = URL(string: dataToAdd["photoURL"] as? String ?? ""),
           let jpegImage = carImage!.jpegData(compressionQuality: 0.8),
           (try? jpegImage.write(to: url)) != nil {
            return true
        }
        return false
    }
    
    func showOverlay(baseFrame: CGRect, propertyName: String) {
        let options = getOptionsForProperty(propertyName: propertyName)
        
        overlayView.frame = self.view.frame
        overlayView.backgroundColor = UIColor.black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        overlayView.addGestureRecognizer(tapGesture)
        overlayView.alpha = 0
        self.view.addSubview(overlayView)
        
        tableView.frame = CGRect(x: baseFrame.origin.x, y: baseFrame.origin.y + baseFrame.height + 50, width: baseFrame.width, height: 0)
        self.view.addSubview(tableView)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: { [self] in
            let maxTableViewHeight = min(CGFloat(options.count) * self.cellHeight, UIScreen.main.bounds.height - (baseFrame.origin.y + baseFrame.height + 50))
            self.tableView.frame = CGRect(x: baseFrame.origin.x, y: baseFrame.origin.y + baseFrame.height + 50, width: baseFrame.width, height: maxTableViewHeight)
            self.overlayView.alpha = 0.5
        }, completion: nil)
    }
    
    func getOptionsForProperty(propertyName: String) -> [String] {
        return ["kek", "cheburek"]
    }
    
    @objc private func removeTransparentView(baseFrame: CGRect) {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.tableView.frame = CGRect(x: baseFrame.origin.x, y: baseFrame.origin.y + baseFrame.height + 50, width: baseFrame.width, height: 0)
            self.overlayView.alpha = 0
        }, completion: nil)
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

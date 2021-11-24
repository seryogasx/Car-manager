//
//  NewVehicleManualAddViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 27.10.2021.
//

import UIKit

enum NewCarContentType {
    case photo
    case input
    case select
    case bool
    case confirm
}

class NewCarManualAddViewController: UIViewController {
    
    @IBOutlet weak var newCarManualAddTableView: UITableView!
    var dataToAdd: [String: Any] = [:]
    
    var carImage: UIImage?
    var rowsCount: Int = 0
    let sectionNumber = Car.paramTypes.count + 1
    let paramTypes = Car.paramTypes
    let propertyNames: [String] = Car.paramNames
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCarManualAddTableView.delegate = self
        newCarManualAddTableView.dataSource = self
        newCarManualAddTableView.register(UINib(nibName: NewCarManualAddTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: NewCarManualAddTableViewCell.reuseIdentifier)
        newCarManualAddTableView.register(UINib(nibName: NewCarManualAddTableViewHeader.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: NewCarManualAddTableViewHeader.reuseIdentifier)
        rowsCount = Car.propertiesCount + 1
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print(#function)
//    }
}

extension NewCarManualAddViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNumber
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == sectionNumber ? 1 : Car.paramTypes[section].1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewCarManualAddTableViewCell.reuseIdentifier, for: indexPath) as? NewCarManualAddTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.section {
            case 0:
                cell.setup(type: .photo, header: nil, text: nil, delegate: self, image: self.carImage)
            case 1:
                let index = Car.paramTypes[0].1 + indexPath.item
                cell.setup(type: .input, header: propertyNames[index], text: dataToAdd[propertyNames[index]] as? String, delegate: self)
            case 2:
                let index = Car.paramTypes[0].1 + Car.paramTypes[1].1 + indexPath.item
                cell.setup(type: .select, header: propertyNames[index], text: dataToAdd[propertyNames[index]] as? String, delegate: self)
            case 3:
                let index = Car.paramTypes[0].1 + Car.paramTypes[1].1 + Car.paramTypes[2].1 + indexPath.item
                cell.setup(type: .bool, header: propertyNames[index], text: nil, delegate: self)
                dataToAdd[propertyNames[index]] = false
            default:
                cell.setup(type: .confirm, header: nil, text: nil, delegate: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 || section == sectionNumber - 1 {
            return nil
        }
        return section == 1 ? "Введите основные данные" : section == 2 ? "Выберете дополнительные данные" : "Дополнительные сведения"
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 || section == sectionNumber - 1 {
//            return UIView()
//        }
//
//        let text = section == 1 ? "Введите основные данные" : section == 2 ? "Выберете дополнительные данные" : "Дополнительные сведения"
//        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewCarManualAddTableViewHeader.reuseIdentifier) as? NewCarManualAddTableViewHeader else {
//            let label = UILabel()
//            label.text = text
//            return label
//        }
//        header.setup(header: text)
//        return header
//    }
}

extension NewCarManualAddViewController: UITableViewDelegate {
}

extension NewCarManualAddViewController: NewCarAddDelegate {
    func updateInfo(key: String, value: Any) {
        dataToAdd[key] = value
        
        if String(describing: dataToAdd[key]) == "" {
            dataToAdd[key] = nil
        }
    }
    
    func confirmChanges() {
        if newCarPropertiesCheck() && StorageManager.shared.saveNewCar(properties: dataToAdd) {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Не все данные введены", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    func photoHasBeenPressed() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}

extension NewCarManualAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName).absoluteString
        self.carImage = image
        dataToAdd["photoURL"] = imagePath
        self.dismiss(animated: true, completion: nil)
        newCarManualAddTableView.reloadSections([0], with: .automatic)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dataToAdd["photoURL"] = nil
        self.dismiss(animated: true, completion: nil)
    }
}

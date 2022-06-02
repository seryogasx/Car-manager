//
//  NewCarViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 11.05.2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol NewCarViewControllerProtocol: UIViewController {
    var viewModel: NewCarViewModelProtocol { get }
    init(viewModel: NewCarViewModelProtocol)
}

struct PropertyCellInfo {
    let label: String
    let cell: UITableViewCell
}

class NewCarViewController: UIViewController, NewCarViewControllerProtocol {
    var viewModel: NewCarViewModelProtocol

    let carDataCells: [[(label: String,
                         attributeText: String,
                         cellType: VisibleCellType,
                         keyboardType: UIKeyboardType?)]] = [
        [(label: "photoURLString", attributeText: "Фото авто", cellType: .carLogo, keyboardType: nil)],
        [(label: "nickName", attributeText: "Псевдоним авто", cellType: .carInfo, keyboardType: .default),
         (label: "mark", attributeText: "Марка авто", cellType: .carInfo, keyboardType: .default),
         (label: "model", attributeText: "Модель авто", cellType: .carInfo, keyboardType: .default),
         (label: "year", attributeText: "Год выпуска", cellType: .carInfo, keyboardType: .numberPad)],
        [(label: "engine", attributeText: "Тип двигателя", cellType: .carInfo, keyboardType: .default),
         (label: "transmissionType", attributeText: "Тип трансмиссии", cellType: .carInfo, keyboardType: .default),
         (label: "mileage", attributeText: "Текущий пробег (км)", cellType: .carInfo, keyboardType: .numberPad),
         (label: "tyreSeasonType", attributeText: "Тип установленной резины", cellType: .carInfo, keyboardType: .default)],
        [(label: "button", attributeText: "Добавить авто", cellType: .carAdd, keyboardType: nil)]
    ]

    let sectionTitle = ["Фото автомобиля", "Основная информация", "Дополнительная информация"]

    var disposeBag = DisposeBag()

    var newCarTableView: UITableView = {
        let newCarTableView = UITableView()
        newCarTableView.delaysContentTouches = true
        newCarTableView.register(NewCarTableViewCell.self, forCellReuseIdentifier: NewCarTableViewCell.reuseIdentifier)
        newCarTableView.separatorStyle = .none
        return newCarTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        newCarTableView.dataSource = self
        newCarTableView.delegate = self
        newCarTableView.rowHeight = UITableView.automaticDimension
        newCarTableView.estimatedRowHeight = 150
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHasBeenShown),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHasBeenDismissed),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
//        addTestCar()
    }

    @objc private func keyboardHasBeenShown(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @objc private func keyboardHasBeenDismissed(notification: Notification) {
        self.view.frame.origin.y = 0
        self.view.setNeedsDisplay()
    }

//    func addTestCar() {
//        let newCar = viewModel.car
//        newCar.nickName = "octaha"
//        newCar.mark = "skoda"
//        newCar.model = "octavia"
//        newCar.year = 2018
//        newCar.engine = "1.4"
//        newCar.transmissionType = .amt
//        newCar.mileage = 100000
//        newCar.tyreSeasonType = .summer
//        let note1 = Note()
//        let note2 = Note()
//        note1.text = "Заменить колодки"
//        note2.text = "Купить огнетушитель"
//        let alert1 = Alert()
//        alert1.text = "Заменить антифриз"
//        newCar.notes.append(objectsIn: [note1, note2])
//        newCar.alerts.append(alert1)
//        viewModel.addCar() { result in
//            switch result {
//                case .success(let message):
//                    let alert = UIAlertController(title: "Авто добавлено в гараж",
//                                                  message: message,
//                                                  preferredStyle: .actionSheet)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
//                    self.present(alert, animated: true)
//                case .failure(let error):
//                    let alert = UIAlertController(title: "Ошибка",
//                                                  message: error.localizedDescription,
//                                                  preferredStyle: .actionSheet)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
//                    self.present(alert, animated: true)
//            }
//        }
//    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }

    private func setConstraints() {
        self.view.addSubview(newCarTableView)
        newCarTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    required init(viewModel: NewCarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewCarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carDataCells[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewCarTableViewCell.reuseIdentifier)
                as? NewCarTableViewCell else {
            print("nothing to reuse")
            return UITableViewCell()
        }
        let cellType = carDataCells[indexPath.section][indexPath.row].cellType
        let carAttribute = carDataCells[indexPath.section][indexPath.row].label
        let carAttributeText = carDataCells[indexPath.section][indexPath.row].attributeText
        switch carDataCells[indexPath.section][indexPath.row].cellType {
            case .carAdd:
                cell.addButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.addButton.addTarget(self, action: #selector(addCarAction), for: .touchUpInside)
                cell.update(attributeText: nil,
                            cellType: cellType,
                            image: nil,
                            text: nil,
                            placeholder: nil)
            case .carInfo:
                let text = String(describing: viewModel.car.value(forKey: carAttribute) as? String ?? "")
                if let keyboardType = carDataCells[indexPath.section][indexPath.row].keyboardType {
                    cell.textField.keyboardType = keyboardType
                    if keyboardType == .numberPad {
                        cell.update(attributeText: carAttributeText,
                                    cellType: cellType,
                                    image: nil,
                                    text: text,
                                    placeholder: "Например: 11")
                    } else {
                        cell.update(attributeText: carAttributeText,
                                    cellType: cellType,
                                    image: nil,
                                    text: text,
                                    placeholder: "Например: aaa")
                    }
                    cell.textField.rx
                        .controlEvent(.editingDidEnd)
                        .withLatestFrom(cell.textField.rx.text.orEmpty)
                        .filter { !$0.isEmpty }
                        .subscribe { [weak self] text in
                            if let self = self {
                                self.viewModel.car
                                    .setValue(text.element, forKey: self.carDataCells[indexPath.section][indexPath.row].label)
                            }
                        }.disposed(by: disposeBag)
                }
            case .carLogo:
                cell.update(attributeText: nil,
                            cellType: cellType,
                            image: viewModel.carLogoImage,
                            text: nil,
                            placeholder: nil)
                cell.viewController = self
                cell.carLogoImage?.subscribe { [weak self] event in
                    self?.viewModel.carLogoImage = event.element
                }.disposed(by: disposeBag)
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return carDataCells.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == sectionTitle.count {
            return ""
        }
        return sectionTitle[section]
    }

    @objc private func addCarAction() {
        viewModel.addCar { result in
            switch result {
                case .success(let message):
                    let alert = UIAlertController(title: "Авто добавлено в гараж",
                                                  message: message,
                                                  preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self.present(alert, animated: true)
                case .failure(let error):
                    let alert = UIAlertController(title: "Ошибка",
                                                  message: error.localizedDescription,
                                                  preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self.present(alert, animated: true)
            }
        }
    }
}

extension NewCarViewController: UITableViewDelegate {

}

//
//  CarDetailsVC.swift
//  CarManager
//
//  Created by Сергей Петров on 25.10.2021.
//

import UIKit
import RxSwift

protocol CarDetailViewControllerProtocol: UIViewController {
    var viewModel: CarDetailsViewModelProtocol { get }
    init(viewModel: CarDetailsViewModelProtocol, car: Car)
    func addNewNote()
}

class CarDetailsViewController: UIViewController, CarDetailViewControllerProtocol {

    var viewModel: CarDetailsViewModelProtocol
    var car: Car!

    lazy var carDetailTableView: NoteTableView = {
        let carDetailTableView = NoteTableView()
        carDetailTableView.setup(estimatedRowHeight: 54.0, rowHeight: UITableView.automaticDimension)
        carDetailTableView.register(AddNoteTableViewCell.self, forCellReuseIdentifier: AddNoteTableViewCell.reuseIdentifier)
        return carDetailTableView
    }()

    lazy var tableHeader: CarDetailTableHeader = {
        let tableHeader = CarDetailTableHeader(car: viewModel.car ?? Car())
        return tableHeader
    }()

    var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        carDetailTableView.dataSource = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHasBeenShown),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHasBeenDismissed),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func setConstraints() {
        self.view.addSubview(carDetailTableView)
        carDetailTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        carDetailTableView.tableHeaderView = tableHeader
        tableHeader.frame = CGRect(x: 0,
                                   y: 0,
                                   width: carDetailTableView.frame.size.width,
                                   height: carDetailTableView.frame.size.width / 2)
    }

    required init(viewModel: CarDetailsViewModelProtocol, car: Car) {
        self.car = car
        self.viewModel = viewModel
        self.viewModel.car = car
        super.init(nibName: nil, bundle: nil)
        setSubscribes()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }

    func setSubscribes() {
        self.viewModel.carSubject.subscribe { [weak self] event in
//            self?.title = event.element?.nickName
            self?.car = event.element
        }.disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}

extension CarDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.car.alerts.isEmpty ? 1 : self.car.alerts.count
        } else if section == 1 {
            return self.car.notes.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CarDetailTableViewAlertCell.reuseIdentifier)
                    as? CarDetailTableViewAlertCell else {
                return UITableViewCell()
            }
            cell.update(alert: self.car.alerts.isEmpty ? nil : self.car.alerts[indexPath.row])
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CarDetailTableViewNoteCell.reuseIdentifier)
                    as? CarDetailTableViewNoteCell else {
                return UITableViewCell()
            }
            cell.update(note: self.car.notes[indexPath.row], placeholder: "Текст заметки")
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddNoteTableViewCell.reuseIdentifier)
                    as? AddNoteTableViewCell else {
                return UITableViewCell()
            }
            cell.update(viewController: self)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return ""
        }
        return section == 0 ? "Предупреждения" : "Заметки"
    }

    func addNewNote() {
        self.viewModel.addNewEmptyNote()
    }
}

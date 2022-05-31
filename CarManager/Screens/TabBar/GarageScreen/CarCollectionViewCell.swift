//
//  CarCollectionViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 22.11.2021.
//

import UIKit
import CoreImage

class CarCollectionViewCell: UICollectionViewCell, ReuseIdentifying {

    var carImageView: CircularImageView = {
        let imageView = CircularImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var carNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var carTableView: NoteTableView = {
        let tableView = NoteTableView()
        tableView.setup(estimatedRowHeight: 40.0, rowHeight: UITableView.automaticDimension)
//        tableView.register(CarNotesTableViewCell.self, forCellReuseIdentifier: CarNotesTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 20
        return tableView
    }()
    
    var car: Car?
    let gradientLayer = CAGradientLayer()
    
    func setup(car: Car? = nil, image: UIImage) {
        self.car = car
        if let car = car {
            carNameLabel.attributedText = AppFonts.mainTitle(string: car.nickName ?? "")
            carNameLabel.textColor = UIColor(red: 34 / 255, green: 34 / 255, blue: 34 / 255, alpha: 1)
            carTableView.delegate = self
            carTableView.dataSource = self
        } else {
            carNameLabel.attributedText = AppFonts.mainTitle(string: "Добавить авто")
            carNameLabel.textColor = UIColor(red: 120 / 255, green: 7 / 255, blue: 20 / 255, alpha: 1)
            carTableView.isHidden = true
        }
        carTableView.reloadData()
        carImageView.image = image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.bounds
        self.gradientLayer.cornerRadius = 20
        self.gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        self.gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        self.gradientLayer.colors = [UIColor(red: 200/255,
                                             green: 200/255,
                                             blue: 200/255,
                                             alpha: 0.2).cgColor,
                                     UIColor(red: 200/255,
                                             green: 200/255,
                                             blue: 200/255,
                                             alpha: 0.5).cgColor]
        if self.gradientLayer.superlayer != self.layer {
            self.layer.insertSublayer(self.gradientLayer, at: 0)
        }
        setConstraints()
    }
    
    private func setConstraints() {
        self.addSubview(carImageView)
        self.addSubview(carNameLabel)
        self.addSubview(carTableView)
        NSLayoutConstraint.activate([
//            carImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: -100),
            carImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            carImageView.centerYAnchor.constraint(equalTo: self.topAnchor),
            carImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                   constant: -self.bounds.width / 5),
            carImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                  constant: self.bounds.width / 5),
            carImageView.heightAnchor.constraint(equalTo: carImageView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            carNameLabel.topAnchor.constraint(equalTo: self.carImageView.bottomAnchor, constant: 10),
            carNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        NSLayoutConstraint.activate([
            carTableView.topAnchor.constraint(equalTo: self.carNameLabel.bottomAnchor, constant: 10),
            carTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            carTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            carTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        carNameLabel.textColor = .black
        carTableView.isHidden = false
        carImageView.image = nil
        self.layer.shadowColor = UIColor.black.cgColor
    }
}

extension CarCollectionViewCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return carTableView.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let car = car {
            if section == 0 {
                return car.alerts.isEmpty ? 1 : car.alerts.count
            } else if section == 1 {
                return car.notes.isEmpty ? 1 : car.notes.count
            } else {
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CarDetailTableViewAlertCell.reuseIdentifier) as? CarDetailTableViewAlertCell,
                  let car = car else {
                return UITableViewCell()
            }
            cell.alertLabel.font = UIFont(name: "verdana", size: 12.0)
            cell.update(alert: car.alerts.isEmpty ? nil : car.alerts[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CarDetailTableViewNoteCell.reuseIdentifier) as? CarDetailTableViewNoteCell,
                  let car = car else {
                return UITableViewCell()
            }
            cell.textView.font = UIFont(name: "verdana", size: 12.0)
            cell.update(note: car.notes.isEmpty ? nil : car.notes[indexPath.row], placeholder: "Пока нет заметок")
            cell.textView.text = "Пока нет заметок"
            cell.textView.isUserInteractionEnabled = false
            print(cell.frame)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return ""
        }
        return section == 0 ? "Предупреждения" : "Заметки"
    }
}

extension CarCollectionViewCell: UITableViewDelegate {
    
}

//extension CarCollectionViewCell: CarNoteCellDelegate {
//    func updateHeightForRow(_ cell: CarNoteTableViewCell, _ textView: UITextView) {
//        return
//    }
    
//    func deleteAction(note: Note) {
//        let index = car?.notes.firstIndex(of: note)
//        if StorageManager.shared.deleteNote(note: note), let index = index {
//            carTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .bottom)
//        }
//    }
//}

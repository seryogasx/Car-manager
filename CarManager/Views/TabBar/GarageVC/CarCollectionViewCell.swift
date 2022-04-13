//
//  CarCollectionViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 22.11.2021.
//

import UIKit
import CoreImage

class CarCollectionViewCell: UICollectionViewCell, ReuseIdentifying {

    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carTableView: UITableView!
    
    var car: Car?
    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        carTableView.register(CarNotesTableViewCell.self, forCellReuseIdentifier: CarNotesTableViewCell.reuseIdentifier)
    }

    func setup(car: Car? = nil, image: UIImage) {
        self.car = car
        carImageView.contentMode = .scaleAspectFill
        carImageView.isUserInteractionEnabled = true
        if let car = car {
            carNameLabel.attributedText = AppFonts.mainTitle(string: car.nickName ?? car.model ?? car.mark ?? "")
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
        self.carImageView.layer.cornerRadius = 20
        self.carTableView.layer.cornerRadius = 20
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return car?.notes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarNotesTableViewCell.reuseIdentifier, for: indexPath) as! CarNotesTableViewCell
        cell.setup(note: car?.notes?.object(at: indexPath.item) as! Note, delegate: self)
        return cell
    }
}

extension CarCollectionViewCell: UITableViewDelegate {
    
}

extension CarCollectionViewCell: CarNoteCellDelegate {
    func updateHeightForRow(_ cell: CarNoteTableViewCell, _ textView: UITextView) {
        return
    }
    
    func deleteAction(note: Note) {
        let index = car?.notes?.index(of: note)
//        if StorageManager.shared.deleteNote(note: note), let index = index {
//            CarTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .bottom)
//        }
    }
}

//
//  CarCollectionViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 22.11.2021.
//

import UIKit
import CoreImage

class CarCollectionViewCell: UICollectionViewCell, ReuseIdentifying {

    @IBOutlet weak var CarImageView: UIImageView!
    @IBOutlet weak var CarNameLabel: UILabel!
    @IBOutlet weak var CarTableView: UITableView!
    
    var car: Car?
    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        CarTableView.layer.cornerRadius = 20
        CarTableView.register(CarNotesTableViewCell.self, forCellReuseIdentifier: CarNotesTableViewCell.reuseIdentifier)
        
//        CarImageView.layer.borderColor = UIColor.black.cgColor
//        CarImageView.layer.cornerRadius = 20
//        CarImageView.layer.borderWidth = 0.5
    }

    func setup(car: Car? = nil, image: UIImage) {
        self.car = car
        CarImageView.contentMode = .scaleAspectFill
        CarImageView.isUserInteractionEnabled = true
        if let car = car {
            CarNameLabel.attributedText = AppFonts.mainTitle(string: car.nickName ?? car.model ?? car.mark ?? "")
            CarNameLabel.textColor = UIColor(red: 34 / 255, green: 34 / 255, blue: 34 / 255, alpha: 1)
            CarTableView.delegate = self
            CarTableView.dataSource = self
        } else {
            CarNameLabel.attributedText = AppFonts.mainTitle(string: "Добавить авто")
            CarNameLabel.textColor = UIColor(red: 120 / 255, green: 7 / 255, blue: 20 / 255, alpha: 1)
            CarTableView.isHidden = true
        }
        CarTableView.reloadData()
        CarImageView.image = image
        
        setupLayer()
    }
    
    private func setupLayer() {
        self.contentView.layer.cornerRadius = 20
        
        setGradient()
        
        if let image = CarImageView.image {
            self.layer.shadowColor = image.averageColor?.cgColor
        }
        self.layer.cornerRadius = self.contentView.layer.cornerRadius
        self.layer.masksToBounds = true
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
        
        self.CarTableView.layer.cornerRadius = self.contentView.layer.cornerRadius
        self.CarImageView.layer.cornerRadius = self.contentView.layer.cornerRadius
    }
    
    private func setGradient() {
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 20
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        gradientLayer.colors = [UIColor(red: 20/255, green: 14/255, blue: 54/255, alpha: 0.3).cgColor, UIColor(red: 9/255, green: 26/255, blue: 171/255, alpha: 0.6).cgColor]
        
        if gradientLayer.superlayer != self.layer {
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        CarNameLabel.textColor = .black
        CarTableView.isHidden = false
        CarImageView.image = nil
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
        if StorageManager.shared.deleteNote(note: note), let index = index {
            CarTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .bottom)
        }
    }
}

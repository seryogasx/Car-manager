//
//  VehicleDetailViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 25.10.2021.
//

import UIKit

class CarDetailViewController: UIViewController {
    
    @IBOutlet weak var CarDetailTableView: UITableView!
    
    let carNoteIdentifier = "CarNoteTableViewCell"
    let carTitleIdentifier = "CarTitleTableViewCell"
    let carInfoIdentifier = "CarInfoTableViewCell"
    var car: Car?
    let notes = ["bla-bla1", "bla-bla2", "bla-bla3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = car?.value(forKey: "nickName") as? String ?? car?.value(forKey: "model") as? String ?? car?.value(forKey: "mark") as? String
        CarDetailTableView.register(UINib(nibName: "CarNoteTableViewCell", bundle: nil), forCellReuseIdentifier: carNoteIdentifier)
        CarDetailTableView.register(UINib(nibName: "CarTitleTableViewCell", bundle: nil), forCellReuseIdentifier: carTitleIdentifier)
        CarDetailTableView.register(UINib(nibName: "CarInfoTableViewCell", bundle: nil), forCellReuseIdentifier: carInfoIdentifier)
        CarDetailTableView.delegate = self
        CarDetailTableView.dataSource = self
    }

}

extension CarDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? notes.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: carTitleIdentifier, for: indexPath) as? CarTitleTableViewCell else {
                    return UITableViewCell()
                }
                cell.setup(name: title!)
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: carInfoIdentifier, for: indexPath) as? CarInfoTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.setup(mark: car?.value(forKey: "mark") as? String, model: car?.value(forKey: "model") as? String, year: car?.value(forKey: "year") as? String, mileage: car?.value(forKey: "mark") as? String)
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: carNoteIdentifier, for: indexPath) as? CarNoteTableViewCell else {
                    return UITableViewCell()
                }
                cell.setup(text: notes[indexPath.item])
                return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}

extension CarDetailViewController: UITableViewDelegate {
    
}

extension CarDetailViewController: NoteCellDelegate {
    func updateHeightForRow(_ cell: CarNoteTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = CarDetailTableView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            CarDetailTableView.beginUpdates()
            CarDetailTableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = CarDetailTableView.indexPath(for: cell) {
                CarDetailTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}

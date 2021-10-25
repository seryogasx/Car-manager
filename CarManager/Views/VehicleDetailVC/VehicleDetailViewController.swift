//
//  VehicleDetailViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 25.10.2021.
//

import UIKit

class VehicleDetailViewController: UIViewController {
    
    @IBOutlet weak var VehicleDetailTableView: UITableView!
    
    let vehicleNoteIdentifier = "VehicleNoteTableViewCell"
    let vehicleTitleIdentifier = "VehicleTitleTableViewCell"
    let vehicleInfoIdentifier = "VehicleInfoTableViewCell"
    var vehicleName = ""
    let notes = ["bla-bla1", "bla-bla2", "bla-bla3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = vehicleName
        VehicleDetailTableView.register(UINib(nibName: "VehicleNoteTableViewCell", bundle: nil), forCellReuseIdentifier: vehicleNoteIdentifier)
        VehicleDetailTableView.register(UINib(nibName: "VehicleTitleTableViewCell", bundle: nil), forCellReuseIdentifier: vehicleTitleIdentifier)
        VehicleDetailTableView.register(UINib(nibName: "VehicleInfoTableViewCell", bundle: nil), forCellReuseIdentifier: vehicleInfoIdentifier)
        VehicleDetailTableView.delegate = self
        VehicleDetailTableView.dataSource = self
    }

}

extension VehicleDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? notes.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: vehicleTitleIdentifier, for: indexPath) as? VehicleTitleTableViewCell else {
                    return UITableViewCell()
                }
                cell.setup(name: "octavia")
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: vehicleInfoIdentifier, for: indexPath) as? VehicleInfoTableViewCell else {
                    return UITableViewCell()
                }
                cell.setup(mark: "Skoda", model: "Octavia", year: "2018", mileage: "90.000km")
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: vehicleNoteIdentifier, for: indexPath) as? VehicleNoteTableViewCell else {
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

extension VehicleDetailViewController: UITableViewDelegate {
    
}

extension VehicleDetailViewController: NoteCellDelegate {
    func updateHeightForRow(_ cell: VehicleNoteTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = VehicleDetailTableView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            VehicleDetailTableView.beginUpdates()
            VehicleDetailTableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = VehicleDetailTableView.indexPath(for: cell) {
                VehicleDetailTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}

//
//  VehicleDetailViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 25.10.2021.
//

import UIKit

class CarDetailViewController: UIViewController {
    
    @IBOutlet weak var CarDetailTableView: UITableView!

    var car: Car!
    
    let sectionIndex: [String: Int] = ["Photo": 0, "Info": 1, "Note": 2, "Delete": 3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = car.nickName ?? car.model ?? car.mark
        CarDetailTableView.register(UINib(nibName: CarNoteTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CarNoteTableViewCell.reuseIdentifier)
        CarDetailTableView.register(UINib(nibName: CarTitleTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CarTitleTableViewCell.reuseIdentifier)
        CarDetailTableView.register(UINib(nibName: CarInfoTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CarInfoTableViewCell.reuseIdentifier)
        CarDetailTableView.register(UINib(nibName: AddNoteTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: AddNoteTableViewCell.reuseIdentifier)
        CarDetailTableView.delegate = self
        CarDetailTableView.dataSource = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let notesToDelete = car.notes?.filter({ ($0 as! Note).text == "" }) {
            for note in notesToDelete {
                StorageManager.shared.deleteNote(note: note as! Note)
            }
        }
    }
}

extension CarDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? car.notes?.count ?? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CarTitleTableViewCell.reuseIdentifier, for: indexPath) as? CarTitleTableViewCell else {
                    return UITableViewCell()
                }
                if let str = car.photoURL, let url = URL(string: str) {
                    cell.setup(name: title!, image: try? UIImage(data: Data(contentsOf: url)))
                } else {
                    cell.setup(name: title!, image: nil)
                }
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CarInfoTableViewCell.reuseIdentifier, for: indexPath) as? CarInfoTableViewCell else {
                    return UITableViewCell()
                }
                cell.setup(mark: car.mark, model: car.model, year: car.year, mileage: car.mileage)
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CarNoteTableViewCell.reuseIdentifier, for: indexPath) as? CarNoteTableViewCell else {
                    return UITableViewCell()
                }
                let note = car.notes![indexPath.item] as! Note
                cell.setup(note: note, delegate: self)
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AddNoteTableViewCell.reuseIdentifier) as? AddNoteTableViewCell else { return UITableViewCell() }
                cell.setup(delegate: self)
                return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionIndex.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.shared.deleteNote(note: self.car.notes![indexPath.item] as! Note)
        }
    }
}

extension CarDetailViewController: CarNoteCellDelegate {
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
    
    func deleteAction(note: Note) {
        let index = (car.notes?.index(of: note))!
        if StorageManager.shared.deleteNote(note: note) {
            CarDetailTableView.deleteRows(at: [IndexPath(row: index, section: sectionIndex["Note"]!)], with: .bottom)
        }
    }
}

extension CarDetailViewController: AddNoteProtocol {
    func addAction() {
        guard let newNote = StorageManager.shared.createNewNote() else { return }
        newNote.isComplete = false
        newNote.text = ""
        car.addToNotes(newNote)
        CarDetailTableView.insertRows(at: [IndexPath(row: car.notes!.count - 1, section: sectionIndex["Note"]!)], with: .top)
    }
}

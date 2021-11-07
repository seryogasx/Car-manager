//
//  VehicleNoteTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 25.10.2021.
//

import UIKit

protocol CarNoteCellDelegate: AnyObject {
    func updateHeightForRow(_ cell: CarNoteTableViewCell, _ textView: UITextView)
    func deleteAction(note: Note)
}

class CarNoteTableViewCell: UITableViewCell, ReuseIdentifying {

    @IBOutlet weak var DoneButton: UIButton!
    @IBOutlet weak var NoteTextView: UITextView!
    
    var note: Note!
    
    weak var delegate: CarNoteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NoteTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
    }
    
    func setup(note: Note, delegate: CarNoteCellDelegate) {
        self.note = note
        NoteTextView.text = note.text
        NoteTextView.isUserInteractionEnabled = true
        self.delegate = delegate
        DoneButton.addTarget(self, action: #selector(endNoteButtonPressed), for: .touchUpInside)
        DoneButton.titleLabel?.text = "Finish"
    }
    
    @objc private func endNoteButtonPressed() {
        note.isComplete = !note.isComplete
//        DoneButton.titleLabel?.text = note.isComplete ? "Done" : "Finish"
        DoneButton.setTitle(note.isComplete ? "Done" : "Finish", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            if self?.note.isComplete == true {
                self?.deleteNote(delay: 0.0)
            }
        }
    }
    
    private func deleteNote(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.delegate?.deleteAction(note: (self?.note)!)
        }
    }
}

extension CarNoteTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = delegate {
            delegate.updateHeightForRow(self, NoteTextView)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            note.text = ""
            deleteNote(delay: 0.5)
        }
        if textView.text != note.text {
            note.text = textView.text
            StorageManager.shared.updateStorage()
        }
    }
}

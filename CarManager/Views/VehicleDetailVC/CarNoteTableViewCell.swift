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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                print("delete start")
                self?.delegate?.deleteAction(note: (self?.note)!)
            }
        }
        if textView.text != note.text {
            note.text = textView.text
            StorageManager.shared.updateStorage()
        }
    }
}

//
//  VehicleNoteTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 25.10.2021.
//

import UIKit

protocol NoteCellDelegate: AnyObject {
    func updateHeightForRow(_ cell: CarNoteTableViewCell, _ textView: UITextView)
}

class CarNoteTableViewCell: UITableViewCell, ReuseIdentifying {

    @IBOutlet weak var DoneButton: UIButton!
    @IBOutlet weak var NoteTextView: UITextView!
    
    weak var rowHeightDelegate: NoteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NoteTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
    }
    
    func setup(text: String) {
        NoteTextView.text = text
    }
}

extension CarNoteTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = rowHeightDelegate {
            delegate.updateHeightForRow(self, NoteTextView)
        }
    }
}

//
//  AddNoteTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 04.11.2021.
//

import UIKit

protocol AddNoteProtocol: AnyObject {
    func addAction()
}

class AddNoteTableViewCell: UITableViewCell, ReuseIdentifying {

    @IBOutlet weak var addNoteButton: UIButton!
    
    weak var delegate: AddNoteProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup(delegate: AddNoteProtocol) {
        self.delegate = delegate
        addNoteButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc func buttonClicked() {
        delegate?.addAction()
    }
}

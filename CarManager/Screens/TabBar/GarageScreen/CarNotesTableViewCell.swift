//
//  CarNotesTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 24.11.2021.
//

import UIKit

class CarNotesTableViewCell: UITableViewCell, ReuseIdentifying {
    
    let noteTextLabel = UILabel()
    let finishButton = UIButton()
    
    var note: Note?
//    weak var delegate: CarNoteCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.subviews.forEach { $0.removeFromSuperview() }
    }

//    func setup(note: Note, delegate: CarNoteCellDelegate) {
//        self.note = note
//        self.delegate = delegate
//        self.contentView.addSubview(finishButton)
//        finishButton.isUserInteractionEnabled = true
//        finishButton.setTitle("◎", for: .normal)
//        finishButton.setTitleColor(.blue, for: .normal)
//        finishButton.addTarget(self, action: #selector(finishButtonPressed(sender:)), for: .touchUpInside)
//        NSLayoutConstraint.activate([
//            finishButton.heightAnchor.constraint(equalToConstant: 20),
//            finishButton.widthAnchor.constraint(equalToConstant: finishButton.frame.height),
//            finishButton.topAnchor.constraint(equalTo: contentView.topAnchor,
//                                              constant: 5),
//            finishButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
//                                                  constant: 5),
//            finishButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
//                                                 constant: -5),
//            finishButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//        ])
//        finishButton.snp.makeConstraints { make in
//            make.height.equalTo(20)
//            make.width.equalTo(finishButton.snp.height)
//            make.top.equalToSuperview().offset(5)
//            make.leading.equalToSuperview().offset(5)
//            make.bottom.equalToSuperview().offset(-5)
//            make.centerY.equalToSuperview()
//        }
        
//        self.contentView.addSubview(noteTextLabel)
//        noteTextLabel.text = note.text//"\(note.isAlert ? "⚠️" : "")\(note.text ?? "")"
//        NSLayoutConstraint.activate([
//            noteTextLabel.leadingAnchor.constraint(equalTo: finishButton.trailingAnchor,
//                                                   constant: 10),
//            noteTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
//                                               constant: 5),
//            noteTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
//                                                  constant: -5),
//            noteTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
//                                                    constant: -5),
//            noteTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//        ])
//        noteTextLabel.snp.makeConstraints { make in
//            make.leading.equalTo(finishButton.snp.trailing).offset(10)
//            make.top.equalToSuperview().offset(5)
//            make.bottom.equalToSuperview().offset(-5)
//            make.trailing.equalToSuperview().offset(-5)
//            make.centerY.equalToSuperview()
//        }
//    }
    
    @objc private func finishButtonPressed(sender: UIButton) {
        
//        if let text = finishButton.titleLabel?.text,
//           text == "◎" {
//            finishButton.setTitle("◉", for: .normal)
//            finishButton.setTitleColor(.green, for: .normal)
////            note?.isComplete = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
//                if let deletedNote = self?.note,
//                   deletedNote.isComplete == true {
//                    self?.delegate?.deleteAction(note: deletedNote)
//                }
//            }
//        } else {
//            finishButton.setTitle("◎", for: .normal)
//            finishButton.setTitleColor(.blue, for: .normal)
//            note?.isComplete = false
//        }
        
    }
}

extension UITableViewCell {
    var tableView: UITableView? {
        var view = superview
        while let currentView = view, currentView.isKind(of: UITableView.self) == false {
            view = currentView
        }
        return view as? UITableView
    }
}

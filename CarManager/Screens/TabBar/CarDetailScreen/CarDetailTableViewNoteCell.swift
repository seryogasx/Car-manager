//
//  CarDetailTableViewNoteCell.swift
//  CarManager
//
//  Created by Сергей Петров on 17.05.2022.
//

import UIKit

class CarDetailTableViewNoteCell: UITableViewCell, ReuseIdentifying {

    var note: Note?
    
    var placeholder: String?
    
    lazy var completeButton: CircularButton = {
        let completeButton = CircularButton()
        completeButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        return completeButton
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.lightGray
        textView.font = UIFont(name: "verdana", size: 16.0)
        textView.returnKeyType = .done
        textView.delegate = self
        textView.isUserInteractionEnabled = true
        return textView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(note: Note?, placeholder: String) {
        self.note = note
        self.placeholder = placeholder
        if let note = note {
            self.placeholder = "Текст Заметки"
            self.textView.text = note.text
        } else {
            self.placeholder = "Текст новой заметки"
            self.textView.text = ""
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.note = nil
        self.placeholder = ""
        self.textView.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        self.contentView.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }
        self.contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalTo(completeButton.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}

extension CarDetailTableViewNoteCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.placeholder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = self.placeholder
            textView.textColor = .lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}

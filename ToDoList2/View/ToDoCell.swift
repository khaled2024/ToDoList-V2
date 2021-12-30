//
//  ToDoCell.swift
//  ToDoList2
//
//  Created by KhaleD HuSsien on 24/12/2021.
//

import UIKit

class ToDoCell: UITableViewCell{
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var NoteTextLabel: UILabel!
    @IBOutlet weak var correctImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func setUp(_ note: Note){
        self.NoteTextLabel.text = note.content
        self.dateTimeLabel.text = note.date
        if note.done {
            self.correctImage.isHidden = false
        }else{
            self.correctImage.isHidden = true
        }
    }
    
}

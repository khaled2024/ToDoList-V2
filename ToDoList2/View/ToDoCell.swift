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
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
    }
}

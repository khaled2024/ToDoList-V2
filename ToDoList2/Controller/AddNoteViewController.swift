//
//  AddNoteViewController.swift
//  ToDoList2
//
//  Created by KhaleD HuSsien on 24/12/2021.
//

import UIKit
protocol passDateDelegate{
    func passData(note: Note)
}

class AddNoteViewController: UIViewController {
    //MARK: - variable
    @IBOutlet weak var DateTimeTF: UITextField!
    @IBOutlet weak var contentTF: UITextField!
    var delegate: passDateDelegate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker()
    }
    //MARK: - functions
    func datePicker(){
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        DateTimeTF.inputView = datePicker
        DateTimeTF.text = formatDate(date: Date())
    }
    
    @objc func dateChange(datePicker: UIDatePicker){
        DateTimeTF.text = formatDate(date: datePicker.date)
    }
    func formatDate(date: Date)-> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    //MARK: - actions
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        if let content = contentTF.text, !content.isEmpty, let date = DateTimeTF.text, !date.isEmpty{
            let newNote = Note(context: self.context)
            newNote.content = content
            newNote.date = date
            delegate?.passData(note: newNote)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
//
//
//func currentDate(){
//    //current date
//    formatter.dateStyle = .medium
//    formatter.timeStyle = .short
//    DateTimeTF.text = formatter.string(from: date)
//}
//func createDatePicker(){
//    let toolbar = UIToolbar()
//    toolbar.sizeToFit()
//    let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
//    toolbar.setItems([done], animated: false)
//    DateTimeTF.inputAccessoryView = toolbar
//    DateTimeTF.inputView = picker
//    picker.preferredDatePickerStyle = .wheels
//    picker.frame.size = CGSize(width: 0, height: 200)
//    picker.datePickerMode = .date
//}
//@objc func donePressed(){
//    formatter.dateStyle = .medium
//    formatter.timeStyle = .short
//    let dateString = formatter.string(from: picker.date)
//    DateTimeTF.text = "\(dateString)"
//    self.view.endEditing(true)
//}
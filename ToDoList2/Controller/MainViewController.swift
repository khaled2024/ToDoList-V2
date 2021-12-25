//
//  MainViewController.swift
//  ToDoList2
//
//  Created by KhaleD HuSsien on 24/12/2021.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    //MARK: - variables
    @IBOutlet weak var tableView: UITableView!
    
    var noteArray = [Note]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        loadNote()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        title = "ToDo-List"
        navigationItem.hidesBackButton = true
    }
    //MARK: - Functions
    private func setUp(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")
    }
    func saveNote(){
        do{
            try context.save()
        }catch{
            print("Error saving context")
        }
        self.tableView.reloadData()
        
    }
    func loadNote(){
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do{
            noteArray =  try context.fetch(request)
        }
        catch{
            print("Error for Fetching Loading Data \(error)")
        }
    }
    func DeleteAlert(){
        let alert = UIAlertController(title: "Sorry", message: "Are you sur u want to delete this to do?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            print("Yes, delete this ToDo")
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: - Actions
    
    @IBAction func addNoteBtnTapped(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let addNoteVC = sb.instantiateViewController(withIdentifier: "AddNoteViewController")as! AddNoteViewController
        addNoteVC.delegate = self
        self.modalPresentationStyle = .automatic
        self.present(addNoteVC, animated: true, completion: nil)
    }
}
//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)as! ToDoCell
        cell.NoteTextLabel.text = noteArray[indexPath.row].content
        cell.dateTimeLabel.text = noteArray[indexPath.row].date
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 1- delete >>>>>>>>>>>
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            // Delete the row from the data source
            self.context.delete(self.noteArray[indexPath.row])
            self.noteArray.remove(at: indexPath.row)
            self.saveNote()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            // Call completion handler with true to indicate
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
}
//MARK: - passDateDelegate
extension MainViewController: passDateDelegate{
    func passData(note: Note) {
        self.noteArray.append(note)
        self.saveNote()
    }
    
}

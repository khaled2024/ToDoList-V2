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
    
    private let floatingBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .systemPurple
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        // for radius & shadow
//        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.4
        return button
    }()
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(floatingBtn)
        setUp()
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        getNotes()
//        loadNote()
    }
    override func viewWillAppear(_ animated: Bool) {
        title = "ToDo-Notes"
        navigationItem.hidesBackButton = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingBtn.frame = CGRect(x: view.frame.size.width - 80, y: view.frame.size.height - 100, width: 60, height: 60)
        floatingBtn.addTarget(self, action: #selector(addNoteBtnTapped), for: .touchUpInside)
    }
    //MARK: - Functions
    @objc private func addNoteBtnTapped(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let addNoteVC = sb.instantiateViewController(withIdentifier: "AddNoteViewController")as! AddNoteViewController
        addNoteVC.delegate = self
        self.modalPresentationStyle = .automatic
        self.present(addNoteVC, animated: true, completion: nil)
    }
    
    func getNotes(){
        let email = UserDefultsManager.shared().email
        print(email)
        do{
        let fetchRequest: NSFetchRequest<Note>
        fetchRequest = Note.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email LIKE %@", email)
        noteArray = try context.fetch(fetchRequest)
            print(noteArray)
        }catch{
            print(error)
        }
    }
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
    @IBAction func exitBtnTapped(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: "LoginViewController")as! LoginViewController
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .flipHorizontal
        present(navController, animated: true, completion: nil)
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
            self.noteArray.remove(at: [indexPath.section][indexPath.row])
            self.tableView.deleteRows(at: [indexPath], with: .fade)

            self.saveNote()
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
        print(noteArray)
        self.saveNote()
    }
    
}
//
//do{
//
//    let request = Note.fetchRequest() as NSFetchRequest<Note>
//    let pred = NSPredicate(format:"email = \(email)", "193e00a75148b4006a451452c618ccec")
//    request.predicate = pred
//    self.noteArray =  try context.fetch(request)
//    DispatchQueue.main.async {
//        self.tableView.reloadData()
//    }
//}catch{
//    print("Error for feltering data\(error)")
//}

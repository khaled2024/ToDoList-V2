//
//  MainViewController.swift
//  ToDoList2
//
//  Created by KhaleD HuSsien on 24/12/2021.
//

import UIKit
import CoreData
import BLTNBoard
import Firebase

class MainViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var DateTimeTF: UITextField!
    @IBOutlet weak var contentTF: UITextField!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var popupView: UIView!
    //MARK: - variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var indexCell: IndexPath = []
    var noteArray = [Note]()
    private let floatingBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .systemPurple
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        // for radius & shadow
        // button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.4
        return button
    }()
    private lazy var boardManager: BLTNItemManager = {
        let item = BLTNPageItem(title: "Delete Note")
        item.image = UIImage(named: "delete")
        item.actionButtonTitle = "OK"
        item.alternativeButtonTitle = "Maybe Later"
        item.descriptionText = "would You like to Delete this Note"
        item.actionHandler = {_ in
            self.didTapBoardContinue(indexCell: self.indexCell)
        }
        item.alternativeHandler = {_ in
            self.didTapBoardSkip()
        }
        item.appearance.actionButtonColor = .systemRed
        item.appearance.alternativeButtonTitleColor = .gray
        
        return BLTNItemManager(rootItem: item)
    }()
    //MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(floatingBtn)
        setUp()
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        getNotes()
        datePicker()
        //loadNote()
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingBtn.frame = CGRect(x: view.frame.size.width - 80, y: view.frame.size.height - 100, width: 60, height: 60)
        floatingBtn.addTarget(self, action: #selector(addNoteBtnTapped), for: .touchUpInside)
    }
    @objc private func addNoteBtnTapped(){
        AnimateIn(desireView: blurView)
        AnimateIn(desireView: popupView)
    }
    //MARK: - private Functions
    private func setUp(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")
        // blurView & size
        blurView.bounds = self.view.bounds
        //set popup 90% of width & 40% of height
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
    }
    private func setUpNavigationBar(){
        title = "ToDo-Notes"
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPurple ]
    }
    private func datePicker(){
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
    // for blur & popup
    func AnimateIn(desireView: UIView){
        let backgroundView = self.view!
        backgroundView.addSubview(desireView)
        //set the view scalling 120%
        desireView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desireView.alpha = 0
        desireView.center = backgroundView.center
        // animate the effect
        UIView.animate(withDuration: 0.3) {
            desireView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desireView.alpha = 1
        }
    }
    func AnimateOut(desireView: UIView){
        UIView.animate(withDuration: 0.3) {
            desireView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desireView.alpha = 0
        } completion: { _ in
            desireView.removeFromSuperview()
        }
    }
    private func getNotes(){
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
    private func didTapBoardContinue(indexCell: IndexPath){
        print("didTapBoardContinue")
        context.delete(self.noteArray[indexCell.row])
        self.noteArray.remove(at: indexCell.row)
        self.tableView.deleteRows(at: [indexCell], with: .fade)
        self.saveNote()
        self.dismiss(animated: true, completion: nil)
    }
    private func didTapBoardSkip(){
        print("didTapBoardSkip")
        self.dismiss(animated: true, completion: nil)
    }
    private func saveNote(){
        do{
            try context.save()
        }catch{
            print("Error saving context")
        }
        self.tableView.reloadData()
    }
    private func loadNote(){
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do{
            noteArray =  try context.fetch(request)
        }
        catch{
            print("Error for Fetching Loading Data \(error)")
        }
    }
    private func ReturnToLogin(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: "LoginViewController")as! LoginViewController
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .flipHorizontal
        self.present(navController, animated: true, completion: nil)
    }
    private func newNote()-> Bool{
        let def = UserDefaults.standard
        if let content = contentTF.text, !content.isEmpty, let date = DateTimeTF.text, !date.isEmpty, let email = def.object(forKey: "email")as? String{
            let newNote = Note(context: self.context)
            newNote.email = email
            print(email)
            newNote.content = content
            newNote.date = date
            newNote.done = false
            self.noteArray.append(newNote)
            print(noteArray)
            self.saveNote()
            contentTF.text = ""
            return true
        }else{
            return false
        }
    }
    //MARK: - Actions
    @IBAction func exitBtnTapped(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            self.ReturnToLogin()
        }catch let signOutError as NSError{
            print("Error signingout", signOutError)
        }
    }
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        if newNote(){
            AnimateOut(desireView: popupView)
            AnimateOut(desireView: blurView)
        }else{
            getAlert(message: "Pls fill all fields")
        }
    }
}
//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = noteArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)as! ToDoCell
        cell.setUp(note)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noteArray[indexPath.row].done = !noteArray[indexPath.row].done
        saveNote()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            self.boardManager.showBulletin(above: self)
            self.indexCell = indexPath
            self.saveNote()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
}

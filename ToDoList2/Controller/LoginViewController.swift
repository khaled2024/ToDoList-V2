//
//  LoginViewController.swift
//  ToDoList2
//
//  Created by KhaleD HuSsien on 23/12/2021.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    
    //MARK: - Variable
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    //MARK: - Actions
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        if let email = emailTF.text , !email.isEmpty , let password = passwordTF.text , !password.isEmpty{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error{
                    print(error.localizedDescription)
                    self.getAlert(message: "\(error.localizedDescription)")
                }else{
                    // for userDefaults
                    UserDefaults.standard.set(email, forKey: "email")
                    self.performSegue(withIdentifier: "LoginToMain", sender: self)
                }
            }
        }
    }
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        let register = storyboard?.instantiateViewController(withIdentifier: "SignViewController")as! SignViewController
        navigationController?.pushViewController(register, animated: true)
    }
}

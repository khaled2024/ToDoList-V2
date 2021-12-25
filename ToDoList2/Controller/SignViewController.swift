//
//  SignViewController.swift
//  ToDoList2
//
//  Created by KhaleD HuSsien on 23/12/2021.
//

import UIKit
import Firebase

class SignViewController: UIViewController {
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        }
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        if let email = emailTF.text , let password = passwordTf.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error{
                    self.getAlert(message: "\(error.localizedDescription)")
                }else{
                    // move to chat navigation
                    self.getSuccessAlert(title: "Congratulations", message: "Your account created successfully") { _Arg in
                        self.performSegue(withIdentifier: "SignInToSignUp", sender: self)
                    }
                    }
                    
                }
            }
        
    }
        
    }



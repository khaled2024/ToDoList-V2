//
//  UiView + alert.swift
//  ToDoList2
//
//  Created by KhaleD HuSsien on 24/12/2021.
//

import UIKit
extension UIViewController {
  
    
    func getAlert(message: String){
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    func getSuccessAlert(title: String , message: String , completion: ((UIAlertAction) -> Void)?){
       let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
       self.present(alert, animated: true, completion: nil)
   }
    
  
}


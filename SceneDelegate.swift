//
//  SceneDelegate.swift
//  TodoListApp
//
//  Created by KhaleD HuSsien on 07/12/2021.
//

import UIKit
import CoreData
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

   //MARK: -  for Root VCs
    func sceneDidBecomeActive(_ scene: UIScene) {
        setRoot()
    }
    func setRoot(){
        let def = UserDefaults.standard
        if let isLoggedIn = def.object(forKey: "isLoggedIn")as? Bool{
            if isLoggedIn {
                goTOMainScreen()
            }else {
                goTOLoginScreen()
            }
        }
    }
    func goTOMainScreen(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = sb.instantiateViewController(withIdentifier: "MainViewController")as! MainViewController
        let navController = UINavigationController(rootViewController: mainVC)
        self.window?.rootViewController = navController
    }
    func goTOLoginScreen(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: "LoginViewController")as! LoginViewController
        let navController = UINavigationController(rootViewController: loginVC)
        self.window?.rootViewController = navController
    }
   

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
      
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneWillEnterForeground")
    }
}


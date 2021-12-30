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
        print("sceneDidBecomeActive")
        
    }
    func sceneWillEnterForeground(_ scene: UIScene) {
        setRoot()
        print("sceneWillEnterForeground")
    }
    private func setRoot(){
        let def = UserDefaults.standard
        if let isLoggedIn = def.object(forKey: "isLoggedIn")as? Bool{
            if isLoggedIn {
                goTOMainScreen()
            }else {
                goTOLoginScreen()
            }
        }
    }
    private func goTOMainScreen(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = sb.instantiateViewController(withIdentifier: "MainViewController")as! MainViewController
        let navController = UINavigationController(rootViewController: mainVC)
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPurple ]
        self.window?.rootViewController = navController
    }
    private func goTOLoginScreen(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: "LoginViewController")as! LoginViewController
        let navController = UINavigationController(rootViewController: loginVC)
        self.window?.rootViewController = navController
    }
    func applicationWillTerminate(_ application: UIApplication) {
        
        print("applicationWillTerminate")
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive")
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground")
    }
    
}


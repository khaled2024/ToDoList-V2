//
//  AppDelegate.swift
//  ToDoList2
//
//  Created by KhaleD HuSsien on 23/12/2021.
//

import UIKit
import Firebase
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        setRoot()
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: UISceneSession Lifecycle

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
  

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
       
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


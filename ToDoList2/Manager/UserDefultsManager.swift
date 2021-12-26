//
//  UserDefultsManager.swift
//  ToDoList2
//
//  Created by KhaleD HuSsien on 25/12/2021.
//

import Foundation
class UserDefultsManager{
    //MARK: - Signleton
    private static let sharedInstance = UserDefultsManager()
    static func shared() ->UserDefultsManager{
        return UserDefultsManager.sharedInstance
    }
    //MARK: - variabels
    
    private let def = UserDefaults.standard
    
    var isLoggedIn: Bool{
        set{
            def.set(newValue, forKey: "isLoggedIn")
        }
        get{
            guard def.object(forKey: "isLoggedIn") != nil else  {
                return false
            }
            return def.bool(forKey: "isLoggedIn")
        }
    }
    
    var email: String{
        set{
            def.set(newValue, forKey: "email")
        }
        get{
            guard def.object(forKey: "email") != nil else{
                return "NoThing"
            }
            return def.string(forKey: "email")!
        }
    }
}

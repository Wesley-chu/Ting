//
//  LoginViewController.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/7/4.
//

import Foundation
import UIKit

class LoginViewController:UIViewController {
    
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var pwText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        DBManager.shared.querytUserInfo(id: idText.text!, password: pwText.text!, contro: self) {
            DispatchQueue.main.async {
                Account.shared.id = self.idText.text!
                Account.shared.password = self.pwText.text!
                let toMainTabBarController = MainTabBarController.instantiate()
                let nav = UINavigationController(rootViewController: toMainTabBarController)
                self.appDelegate?.translate(rootViewController: nav)
            }
        }
        
    }
    
    
}


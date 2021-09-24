//
//  RegisterViewController.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/7/5.
//

import Foundation
import UIKit

class RegisterViewController:UIViewController{
    
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var pwAgainText: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func register(_ sender: UIButton) {
        
        
        DBManager.shared.insertUserInfo(id: idText.text!, password: passwordText.text!, pwCheck: pwAgainText.text!, contro: self) { (_, error) in
            if error != nil{
                print(error as Any,"insertUserInfo error")
                return
            }else{
                DispatchQueue.main.async {
                    Account.shared.id = self.idText.text!
                    Account.shared.password = self.passwordText.text!
                    let toMainTabBarController = MainTabBarController.instantiate()
                    let nav = UINavigationController(rootViewController: toMainTabBarController)
                    self.appDelegate?.translate(rootViewController: nav)
                }
            }
        }
        
    }
    
    
    
}

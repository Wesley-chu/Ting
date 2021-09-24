//
//  StartViewController.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/7/5.
//

import Foundation
import UIKit


class StartViewController:UIViewController {
    
    static func instantiate() -> StartViewController{
        let vc = UIStoryboard(name: "RegisterLogin", bundle: nil).instantiateViewController(withIdentifier: "StartViewController") as! StartViewController
        return vc
    }
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func toRegister(_ sender: UIButton) {
        performSegue(withIdentifier: "segue_register", sender: nil)
    }
    
    
    
    @IBAction func toLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "segue_login", sender: nil)
    }
    
    
    
}

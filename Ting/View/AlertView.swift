//
//  alertView.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/7/4.
//

import Foundation
import UIKit

class AlertView {
    static let shared = AlertView()
    func normalAlert(title:String, message:String, okTitle:String, cancel:Bool,  contro:UIViewController, completion:@escaping (UIAlertAction) -> Void){
        let Alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: completion)
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default, handler: nil)
        
        Alert.addAction(okAction)
        if cancel == true { Alert.addAction(cancelAction) }
        contro.present(Alert, animated: true, completion: nil)
    }
    
    
    
    
}

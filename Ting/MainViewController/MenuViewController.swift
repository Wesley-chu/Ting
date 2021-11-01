//
//  MenuViewController.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/8.
//

import Foundation
import UIKit
import StoreKit

class MenuViewController: UIViewController {
    
    static func instantiate() -> MenuViewController{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        return vc
    }
    
    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
    }
    
    
    func initView(){
        self.navigationController?.navigationBar.barTintColor = .white
        menuView.layer.shadowOpacity = 0.2
        menuView.layer.shadowRadius = 3
        menuView.layer.shadowOffset = CGSize(width: -1.0, height: 3.0)
        
        let inquiry = menuView.subviews[0].subviews[0]
        let evaluation = menuView.subviews[0].subviews[1]
        //let twitter = menuView.subviews[0].subviews[2]
        
        let tapEvaluation = UITapGestureRecognizer(target: self, action: #selector(topEvaluation(top:)))
        evaluation.addGestureRecognizer(tapEvaluation)
        
    }
    
    @objc func topEvaluation(top: UITapGestureRecognizer){
        SKStoreReviewController.requestReview()
    }

    
    
    

    
    


}

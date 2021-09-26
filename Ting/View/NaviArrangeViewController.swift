//
//  NavigationBarBackButton.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/9/22.
//

import Foundation
import UIKit

class NaviArrangeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = UIImage(named: "left") else { return }
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = button
        self.navigationItem.leftBarButtonItem?.tintColor = .cusLightYellow
        
    }
    
    @objc func backButton(delegete: UIViewController){
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.popViewController(animated: true)
    }
    
}

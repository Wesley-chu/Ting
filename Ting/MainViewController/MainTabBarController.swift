//
//  MainTabBarController.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/7/6.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var select = false
    var tab1 = TabBarLabel()
    var tab2 = TabBarLabel()
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        settingButton()
    }
    
    
    static func instantiate() -> MainTabBarController{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        return vc
    }

    func settingButton(){
        var tabHeight:CGFloat?
        let mainBoundHeight: CGFloat = UIScreen.main.bounds.size.height
        if mainBoundHeight >= 812{
            tabHeight = 105
        }else{
            tabHeight = 95
        }
        
        var tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
        tabFrame.size.height = tabHeight!; //自行調整想要的高度, 假設是80
        tabFrame.origin.y = self.view.frame.size.height - tabHeight!; //Y的高度必須要重設
        self.tabBar.frame = tabFrame; //把frame重新指回去
        
        tab1.layout(tabBar: self.tabBar, countItem: 2, num: 1, menuType: .learn)
        tab1.underline.isHidden = false
        self.tabBar.addSubview(tab1)
        
        tab2.layout(tabBar: self.tabBar, countItem: 2, num: 2, menuType: .menu)
        self.tabBar.addSubview(tab2)

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "challenge"{
            tab2.underline.isHidden = true
            tab1.underline.isHidden = false
            print(item.title)
        }else{
            tab2.underline.isHidden = false
            tab1.underline.isHidden = true
            print(item.title)
        }
    }
    
    
    
    
}

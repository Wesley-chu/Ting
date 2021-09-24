//
//  tabBarLabel.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/8/23.
//

import Foundation
import UIKit

class TabBarLabel:UILabel {
    
    var underline = UILabel()
    var upline = UILabel()
    var imageView = UIImageView()
    var title = UILabel()
    
    enum menuType {
        case learn
        case menu
    }
    
    func layout(tabBar:UITabBar, countItem:CGFloat, num: Int, menuType: menuType) {
        let width = tabBar.frame.size.width / countItem
        let height = tabBar.frame.size.height
        let imageSize = width * 0.2
        let underlineWidth = width * 0.65
        let mainBoundHeight: CGFloat = UIScreen.main.bounds.size.height
        var dicComponent = [String:String]()
        var imageViewY:CGFloat?
        var titleY:CGFloat?
        var underlineY:CGFloat?
        
        switch menuType {
        case .learn:
            dicComponent["image"] = "learn"
            dicComponent["title"] = "学習"
        case .menu:
            dicComponent["image"] = "menu"
            dicComponent["title"] = "メニュー"
        default:
            break
        }
        if mainBoundHeight >= 812 {
            imageViewY = self.upline.bounds.maxY + 10
            titleY = self.imageView.bounds.maxY + 17
            underlineY = tabBar.bounds.midY + 26
        }else{
            imageViewY = self.upline.bounds.maxY + 15
            titleY = self.imageView.bounds.maxY + 25
            underlineY = tabBar.bounds.midY + 38
        }
        self.frame.size = CGSize(width: width, height: height)
        if num == 1{
            self.frame.origin.x = 0
        }else{
            self.frame.origin.x = tabBar.bounds.minX + width * CGFloat((num - 1))
        }
        
        self.frame.origin.y = tabBar.bounds.minY
        self.backgroundColor = UIColor(hexString: "5856D6")
        
        self.upline.frame.size = CGSize(width: width, height: 5)
        self.upline.center.x = self.bounds.midX
        self.upline.frame.origin.y = tabBar.bounds.minY
        self.upline.backgroundColor = UIColor(hexString: "FFCC00")
        self.addSubview(self.upline)
        
        self.imageView.frame.size = CGSize(width: imageSize, height: imageSize)
        self.imageView.center.x = self.bounds.midX
        self.imageView.frame.origin.y = imageViewY!
        self.imageView.image = UIImage(named: dicComponent["image"] ?? "")
        self.addSubview(self.imageView)
        
        self.title.frame.size = CGSize(width: underlineWidth * 0.45, height: 20)
        self.title.center.x = self.bounds.midX
        self.title.frame.origin.y = titleY!
        self.title.text = dicComponent["title"] ?? ""
        self.title.textColor = .white
        self.title.textAlignment = NSTextAlignment.center
        self.title.adjustsFontSizeToFitWidth = true
        self.title.minimumScaleFactor = 0.3
        self.title.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(self.title)
        
        self.underline.frame.size = CGSize(width: underlineWidth , height: 2)
        self.underline.center.x = self.bounds.midX
        self.underline.frame.origin.y = underlineY!
        self.underline.backgroundColor = UIColor(hexString: "FFCC00")
        self.addSubview(self.underline)
        self.underline.isHidden = true
        
    }

    
}

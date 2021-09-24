//
//  ActivityIndicatorView.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/10.
//

import Foundation
import UIKit

class ActivityIndicatorView {
    static let shared = ActivityIndicatorView()
    //等待的小圈圈
    var activityIndicator = UIActivityIndicatorView()
    func activityIndicatorView(flg:loading,view:UIView){
        if flg == .start{
            UIApplication.shared.beginIgnoringInteractionEvents()
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }else if flg == .end{
            UIApplication.shared.endIgnoringInteractionEvents()
            activityIndicator.stopAnimating()
        }
    }
    
    
    
    
}

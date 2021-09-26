//
//  GuideView.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/9/19.
//

import Foundation
import UIKit

class GuideView :UIView {
    
    @IBOutlet weak var constCLb: UILabel!
    @IBOutlet weak var constJLb: UILabel!
    @IBOutlet weak var exampleCLb: UILabel!
    @IBOutlet weak var exampleJLb: UILabel!
    @IBOutlet weak var exampleVoiceBt: UIButton!
    
    
    // コードから呼び出す際に使用される
    override init(frame: CGRect) {
            super.init(frame: frame)
            loadNib()
        }
    
    // Storyboardから利用する際に使用される
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            loadNib()
        }
    
    // 上記どちらのinitからも使用される共通関数で、xibファイルを呼び出す。
    func loadNib() {
            // 第1引数のnameには、xibファイル名
            // ownerはself固定
            // optionsはここではnil
        let view = Bundle.main.loadNibNamed("GuideView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        }
    
    
    
}

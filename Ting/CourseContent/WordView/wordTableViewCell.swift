//
//  wordTableViewCell.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/9/21.
//

import UIKit

class wordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var wordcLb: UILabel!
    @IBOutlet weak var wordjLb: UILabel!
    @IBOutlet weak var voiceBt: UIButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  FavoriteButton.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/7.
//

import Foundation
import UIKit

class FavoriteButton:UIButton {
    
    func tapFavoriteButton(sender:FavoriteButton,arr:inout Array<VideoInfo>){
        
        guard let row = Int(sender.accessibilityIdentifier!) else { return }
        let videoId = arr[row].videoId!
        let title = arr[row].title!
        let subtitle = arr[row].subtitle!
        let time = arr[row].time!
        let imageURL = arr[row].imageURL!
        let level = arr[row].level!
        let genre = arr[row].genre!
        switch sender.titleLabel?.text {
        case "💛":
            sender.setTitle("❤️", for: .normal)
            arr[row].buttonTitle = "❤️"
            CoreDataManager.shared.DealWithCoreData(coreStyle: .save, videoId: videoId, title: title, subtitle: subtitle, time: time, imageURL: imageURL, level: level, genre: genre)
            
        case "❤️":
            sender.setTitle("💛", for: .normal)
            arr[row].buttonTitle = "💛"
            CoreDataManager.shared.DealWithCoreData(coreStyle: .delete, videoId: videoId, title: title, subtitle: subtitle, time: time, imageURL: imageURL, level: level, genre: genre)
            
        default: break
        }
    }
    
    func checkIfFavor(core:[CoreVideoInfo],videoId:String) -> String{
        //判斷有沒有在我的最愛
        for favor in core{
            if favor.videoId == videoId{
                return "❤️"
            }
        }
        return "💛"
    }
    
    
    
}

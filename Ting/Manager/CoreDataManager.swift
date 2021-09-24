//
//  CoreData.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/6.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager{
    static let shared = CoreDataManager()
    let appDel = UIApplication.shared.delegate as? AppDelegate
    func DealWithCoreData(coreStyle:coreStyle,videoId:String,title:String,subtitle:String,time:String,imageURL:String,level:String,genre:String){
        guard let context = appDel?.persistentContainer.viewContext else{ return }
        if coreStyle == .save{
            let aVideoInfo = CoreVideoInfo(context: context)
            aVideoInfo.videoId = videoId
            aVideoInfo.title = title
            aVideoInfo.subtitle = subtitle
            aVideoInfo.time = time
            aVideoInfo.imageURL = imageURL
            aVideoInfo.level = level
            aVideoInfo.genre = genre
            appDel?.saveContext()
        }else if coreStyle == .delete{
            for check in coreDataQuery(){
                guard let checkVideoId = check.videoId else { return }
                if checkVideoId == videoId{ context.delete(check) }
                appDel?.saveContext()
            }
        }
    }
    
    func coreDataQuery() -> [CoreVideoInfo]{
        guard let context = appDel?.persistentContainer.viewContext else{ return [CoreVideoInfo()]}
        do{
            let results = try context.fetch(CoreVideoInfo.fetchRequest())
            guard let aVideoInfo = results as? [CoreVideoInfo] else { return [CoreVideoInfo()] }
            return aVideoInfo
        }catch{ return [CoreVideoInfo()] }
    }
    
    
    
}

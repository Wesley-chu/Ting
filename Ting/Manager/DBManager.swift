//
//  DBManager.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/6.
//

import Foundation
import CloudKit
import UIKit

class DBManager{
    static let shared = DBManager()
    
    let database = CKContainer(identifier: "iCloud.com.Chuweilun.vedioAdmin").publicCloudDatabase
    let queryUsersInfo = CKQuery(recordType: recordType.usersInfo.rawValue, predicate: NSPredicate(value: true))
    let queryVideosInfo = CKQuery(recordType: recordType.videosInfo.rawValue, predicate: NSPredicate(value: true))
    let queryGrammarList = CKQuery(recordType: recordType.grammarList.rawValue, predicate: NSPredicate(value: true))
    let queryGrammarContent = CKQuery(recordType: recordType.grammarContent.rawValue, predicate: NSPredicate(value: true))
    let queryWords = CKQuery(recordType: recordType.words.rawValue, predicate: NSPredicate(value: true))
    let queryGrammarTraining = CKQuery(recordType: recordType.grammarTraining.rawValue, predicate: NSPredicate(value: true))
    
    
    func insertUserInfo(id:String, password:String, pwCheck:String, contro:UIViewController, completionHandler:@escaping(CKRecord?, Error?) -> Void){
        let save = CKRecord(recordType: recordType.usersInfo.rawValue)
        queryUsersInfo.sortDescriptors = [NSSortDescriptor(key: "uid", ascending: false)]
        let operation = CKQueryOperation(query: queryUsersInfo)
        operation.queuePriority = .veryHigh
        operation.resultsLimit = 3000
        var uid = ""
        var setUid = false
        var checkId = false
        operation.recordFetchedBlock = {(records:CKRecord?) in
            guard let record = records else { return }
            if setUid == false{
                uid = record["uid"] as! String
                setUid = true
            }
            if id == record["id"] as! String{
                DispatchQueue.main.async{
                    AlertView.shared.normalAlert(title: "", message: "このIDは既に使われています。", okTitle: "確認", cancel: false, contro: contro) {_ in }
                }
                checkId = true
                return
            }
        }
        operation.queryCompletionBlock = { (cursor,error) in
            if checkId == true { return }
            if error != nil{
                print(error as Any,"insertUserInfo error")
                return
            }
            if password != pwCheck {
                DispatchQueue.main.async{
                    AlertView.shared.normalAlert(title: "", message: "パスワードが不一致しています。", okTitle: "確認", cancel: false, contro: contro) {_ in }
                }
                return
            }
            if uid == ""{ uid = "1" }
            else{ uid = String(Int(uid)! + 1) }
            save.setValue(id, forKey: "id")
            save.setValue(uid, forKey: "uid")
            save.setValue(password, forKey: "password")
            self.database.save(save, completionHandler: completionHandler)
        }
        database.add(operation)
    }
    
    
    
    func querytUserInfo(id:String, password:String, contro:UIViewController, completionHandler:@escaping() -> Void){
        queryUsersInfo.sortDescriptors = [NSSortDescriptor(key: "uid", ascending: false)]
        let operation = CKQueryOperation(query: queryUsersInfo)
        operation.queuePriority = .veryHigh
        operation.recordFetchedBlock = {(records:CKRecord?) in
            guard let record = records else { return }
            if id == record["id"] as! String && password == record["password"] as! String {
                let com: Void = completionHandler()
                com
                return
            }else{
                DispatchQueue.main.async{
                    AlertView.shared.normalAlert(title: "", message: "パスワードが間違っています。", okTitle: "確認", cancel: false, contro: contro) {_ in }
                }
                return
            }
        }
        operation.queryCompletionBlock = { (cursor,error) in
            if error != nil{
                print(error as Any,"queryUserInfo error")
                return
            }
        }
        database.add(operation)
    }
    
    func queryWords(words:[String],view:UIView, handle:@escaping() -> Void){
        ActivityIndicatorView.shared.activityIndicatorView(flg: .start, view: view)
        let database = DBManager.shared.database
        let query = DBManager.shared.queryWords
        let operation = CKQueryOperation(query: query)
        operation.recordFetchedBlock = {(records:CKRecord?) in
            guard let record = records else { return }
            for i in words{
                if record["wordId"] as! String == i{
                    let data = Words(wordId: record["wordId"] as! String, Chinese: record["Chinese"] as! String, Japanese: record["Japanese"] as! String)
                    handle()
                }
            }
        }
        operation.queryCompletionBlock = {(cursor,error) in
            if error != nil{
                print(error,"queryWords error")
            }
            DispatchQueue.main.async {
                ActivityIndicatorView.shared.activityIndicatorView(flg: .end, view: view)
            }
        }
        database.add(operation)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

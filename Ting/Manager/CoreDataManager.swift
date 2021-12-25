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
    
    func coreGrammarListSave(grammarId:String, grammarTitle:String, groupId:String, levelId:String, unitId:String){
        guard let context = appDel?.persistentContainer.viewContext else{ return }
        let aGrammarList = CoreGrammarList(context: context)
        aGrammarList.grammarId = grammarId
        aGrammarList.grammarTitle = grammarTitle
        aGrammarList.groupId = groupId
        aGrammarList.levelId = levelId
        aGrammarList.unitId = unitId
        appDel?.saveContext()
    }
    func coreGrammarListQuery() ->[CoreGrammarList] {
        guard let context = appDel?.persistentContainer.viewContext else{ return [CoreGrammarList()]}
        do{
            let results = try context.fetch(CoreGrammarList.fetchRequest())
            guard let aGrammarList = results as? [CoreGrammarList] else { return [CoreGrammarList()] }
            return aGrammarList
        }catch{ return [CoreGrammarList()] }
    }
    
    
    func coreGrammarContentSave(constC:String, constJ:String, example:String, unitId:String, words:String){
        guard let context = appDel?.persistentContainer.viewContext else{ return }
        let aGrammarContent = CoreGrammarContent(context: context)
        aGrammarContent.constC = constC
        aGrammarContent.constJ = constJ
        aGrammarContent.example = example
        aGrammarContent.unitId = unitId
        aGrammarContent.words = words
        appDel?.saveContext()
    }
    func coreGrammarContentQuery() ->[CoreGrammarContent] {
        guard let context = appDel?.persistentContainer.viewContext else{ return [CoreGrammarContent()]}
        do{
            let results = try context.fetch(CoreGrammarContent.fetchRequest())
            guard let aGrammarContent = results as? [CoreGrammarContent] else { return [CoreGrammarContent()] }
            return aGrammarContent
        }catch{ return [CoreGrammarContent()] }
    }
    
    
    func coreGrammarTrainingSave(sentence1:String, sentence2:String, sentence3:String, sentence4:String, sentence5:String, unitId:String){
        guard let context = appDel?.persistentContainer.viewContext else{ return }
        let aGrammarTraining = CoreGrammarTraining(context: context)
        aGrammarTraining.sentence1 = sentence1
        aGrammarTraining.sentence2 = sentence2
        aGrammarTraining.sentence3 = sentence3
        aGrammarTraining.sentence4 = sentence4
        aGrammarTraining.sentence5 = sentence5
        aGrammarTraining.unitId = unitId
        appDel?.saveContext()
    }
    func coreGrammarTrainingQuery() ->[CoreGrammarTraining] {
        guard let context = appDel?.persistentContainer.viewContext else{ return [CoreGrammarTraining()]}
        do{
            let results = try context.fetch(CoreGrammarTraining.fetchRequest())
            guard let aGrammarTraining = results as? [CoreGrammarTraining] else { return [CoreGrammarTraining()] }
            return aGrammarTraining
        }catch{ return [CoreGrammarTraining()] }
    }
    
    
    func coreWordsSave(Chinese:String, Japanese:String, wordId:String){
        guard let context = appDel?.persistentContainer.viewContext else{ return }
        let aWords = CoreWords(context: context)
        aWords.chinese = Chinese
        aWords.japanese = Japanese
        aWords.wordId = wordId
        appDel?.saveContext()
    }
    func coreWordsQuery() ->[CoreWords] {
        guard let context = appDel?.persistentContainer.viewContext else{ return [CoreWords()]}
        do{
            let results = try context.fetch(CoreWords.fetchRequest())
            guard let aWords = results as? [CoreWords] else { return [CoreWords()] }
            return aWords
        }catch{ return [CoreWords()] }
    }
    
    
    
}

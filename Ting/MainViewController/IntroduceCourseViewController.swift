//
//  IntroduceCourseViewController.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/8.
//

import Foundation
import UIKit
import CloudKit
import CoreData

class IntroduceCourseViewController: UIViewController {
    
    @IBOutlet weak var level_C: UIButton!
    @IBOutlet weak var level_B: UIButton!
    @IBOutlet weak var level_A: UIButton!
    @IBOutlet weak var level_S: UIButton!
    
    static func instantiate() -> IntroduceCourseViewController{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IntroduceCourseViewController") as! IntroduceCourseViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        initView()
        //saveToCore()
        //coreToProduction()
        //words()
    }
    
    
    @IBAction func course(_ sender: UIButton) {
        switch sender {
        case level_C:
            performSegue(withIdentifier: "segue_gmrList", sender: level.C)
        case level_B:
            performSegue(withIdentifier: "segue_gmrList", sender: level.B)
        case level_A:
            performSegue(withIdentifier: "segue_gmrList", sender: level.A)
        case level_S:
            performSegue(withIdentifier: "segue_gmrList", sender: level.S)
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_gmrList"{
            if let toGrammarListViewController = segue.destination as? GrammarListViewController{
                toGrammarListViewController.postedLevel = sender as! level
            }
        }
    }
    
    func initView(){
        let arr = [level_C,level_B,level_A,level_S]
        arr.forEach {
            $0?.backgroundColor = .cusLightYellow
            $0?.layer.cornerRadius = 5
            $0?.layer.masksToBounds = true
        }
        
        
    }
    
    func saveToCore(){
        let database = DBManager.shared.database
        let query = DBManager.shared.queryGrammarList
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.resultsLimit = 500
        operation.recordFetchedBlock = {(records:CKRecord?) in
            guard let record = records else { return }
            CoreDataManager.shared.coreGrammarListSave(grammarId: record["grammarId"] as! String, grammarTitle: record["grammarTitle"] as! String, groupId: record["groupId"] as! String, levelId: record["levelId"] as! String, unitId: record["unitId"] as! String)
        }
        operation.queryCompletionBlock = {(cursor,error) in
            if error != nil{
                print(error,"error queryGrammarList")
            }else{
                print("queryGrammarList done")
                let query2 = DBManager.shared.queryGrammarContent
                let operation2 = CKQueryOperation(query: query2)
                operation2.queuePriority = .veryHigh
                operation2.resultsLimit = 500
                operation2.recordFetchedBlock = {(records:CKRecord?) in
                    guard let record = records else { return }
                    CoreDataManager.shared.coreGrammarContentSave(constC: record["constC"] as! String, constJ: record["constJ"] as! String, example: record["example"] as! String, unitId: record["unitId"] as! String, words: record["words"] as! String)
                }
                operation2.queryCompletionBlock = {(cursor,error) in
                    if error != nil{
                        print(error,"error queryGrammarContent")
                    }else{
                        print("queryGrammarContent done")
                        let query3 = DBManager.shared.queryGrammarTraining
                        let operation3 = CKQueryOperation(query: query3)
                        operation3.queuePriority = .veryHigh
                        operation3.resultsLimit = 500
                        operation3.recordFetchedBlock = {(records:CKRecord?) in
                            guard let record = records else { return }
                            CoreDataManager.shared.coreGrammarTrainingSave(sentence1: record["sentence1"] as! String, sentence2: record["sentence2"] as! String, sentence3: record["sentence3"] as! String, sentence4: record["sentence4"] as! String, sentence5: record["sentence5"] as! String, unitId: record["unitId"] as! String)
                        }
                        operation3.queryCompletionBlock = {(cursor,error) in
                            if error != nil{
                                print(error,"error queryGrammarTraining")
                            }else{
                                print("queryGrammarTraining done")
                                let query4 = DBManager.shared.queryWords
                                let operation4 = CKQueryOperation(query: query4)
                                operation4.queuePriority = .veryHigh
                                operation4.resultsLimit = 500
                                operation4.recordFetchedBlock = {(records:CKRecord?) in
                                    guard let record = records else { return }
                                    CoreDataManager.shared.coreWordsSave(Chinese: record["Chinese"] as! String, Japanese: record["Japanese"] as! String, wordId: record["wordId"] as! String)
                                }
                                operation4.queryCompletionBlock = {(cursor,error) in
                                    if error != nil{
                                        print(error,"error queryWords")
                                    }else{
                                        print("queryWords done")
                                    }
                                }
                                database.add(operation4)
                            }
                        }
                        database.add(operation3)
                    }
                }
                database.add(operation2)
            }
        }
        database.add(operation)
    }
    
    func coreToProduction(){
        let database = DBManager.shared.database
        var save:CKRecord
        for core in CoreDataManager.shared.coreGrammarListQuery(){
            save = CKRecord(recordType: "grammarList")
            save.setValue(core.unitId, forKey: "unitId")
            save.setValue(core.levelId, forKey: "levelId")
            save.setValue(core.groupId, forKey: "groupId")
            save.setValue(core.grammarId, forKey: "grammarId")
            save.setValue(core.grammarTitle, forKey: "grammarTitle")
            database.save(save) { (_, error) in
                if error != nil{
                    print(error,"error \(core.grammarTitle)")
                }else{
                    print("saveDone \(core.grammarTitle)")
                }
            }
        }
        
        for core2 in CoreDataManager.shared.coreGrammarContentQuery(){
            save = CKRecord(recordType: "grammarContent")
            save.setValue(core2.unitId, forKey: "unitId")
            save.setValue(core2.constC, forKey: "constC")
            save.setValue(core2.constJ, forKey: "constJ")
            save.setValue(core2.example, forKey: "example")
            save.setValue(core2.words, forKey: "words")
            database.save(save) { (_, error) in
                if error != nil{
                    print(error,"error \(core2.example)")
                }else{
                    print("saveDone \(core2.example)")
                }
            }
        }
        
        for core3 in CoreDataManager.shared.coreGrammarTrainingQuery(){
            save = CKRecord(recordType: "grammarTraining")
            save.setValue(core3.unitId, forKey: "unitId")
            save.setValue(core3.sentence1, forKey: "sentence1")
            save.setValue(core3.sentence2, forKey: "sentence2")
            save.setValue(core3.sentence3, forKey: "sentence3")
            save.setValue(core3.sentence4, forKey: "sentence4")
            save.setValue(core3.sentence5, forKey: "sentence5")
            database.save(save) { (_, error) in
                if error != nil{
                    print(error,"error \(core3.unitId)")
                }else{
                    print("saveDone \(core3.unitId)")
                }
            }
        }
        
        for core4 in CoreDataManager.shared.coreWordsQuery(){
            save = CKRecord(recordType: "words")
            save.setValue(core4.wordId, forKey: "wordId")
            save.setValue(core4.chinese, forKey: "Chinese")
            save.setValue(core4.japanese, forKey: "Japanese")
            database.save(save) { (_, error) in
                if error != nil{
                    print(error,"error \(core4.chinese)")
                }else{
                    print("saveDone \(core4.chinese)")
                }
            }
        }
    }
    
    func words(){
        let database = DBManager.shared.database
        var save:CKRecord
        for core4 in CoreDataManager.shared.coreWordsQuery(){
            save = CKRecord(recordType: "words")
            save.setValue(core4.wordId, forKey: "wordId")
            save.setValue(core4.chinese, forKey: "Chinese")
            save.setValue(core4.japanese, forKey: "Japanese")
            database.save(save) { (_, error) in
                if error != nil{
                    print(error,"error \(core4.chinese)")
                }else{
                    print("saveDone \(core4.chinese)")
                }
            }
        }
    }
    
    
}

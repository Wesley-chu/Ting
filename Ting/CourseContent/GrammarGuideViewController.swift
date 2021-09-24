//
//  GrammarGuideViewController.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/17.
//

import Foundation
import UIKit
import CloudKit
import AVFoundation

class GrammarGuideViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    var unitId:String?
    var words = [Words]()
    var content = GrammarContent()
    var loading = ActivityIndicatorView()
    var voice = VoiceManager()
    
    @IBOutlet weak var constClabel: UILabel!
    @IBOutlet weak var constJlabel: UILabel!
    @IBOutlet weak var exLabel: UILabel!
    
    @IBOutlet weak var voiceButton: UIButton!
    
    @IBOutlet weak var wordsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordsTableView.delegate = self
        wordsTableView.dataSource = self
        queryGmrGuide(unitId: unitId!)
        
    }
    
    @IBAction func exVoice(_ sender: UIButton) {
        guard let exText = content.example?.components(separatedBy: "_")[0] else { return }
        //let AVSpeechUtteranceMinimumSpeechRate: Float
        //let AVSpeechUtteranceDefaultSpeechRate: Float
        //let AVSpeechUtteranceMaximumSpeechRate: Float
        voice.speak(text: exText, language: .zh_TW, rate: 0.4, pitch: 1.0)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_word", for: indexPath)
        guard let labelC = cell.viewWithTag(1) as? UILabel else { return cell }
        guard let labelJ = cell.viewWithTag(2) as? UILabel else { return cell }
        guard let wordVoice = cell.viewWithTag(3) as? UIButton else { return cell }
        labelC.text = words[indexPath.row].Chinese
        labelJ.text = words[indexPath.row].Japanese
        wordVoice.accessibilityIdentifier = String(indexPath.row)
        wordVoice.addTarget(self, action: #selector(wordsVoice(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func queryGmrGuide(unitId:String){
        loading.activityIndicatorView(flg: .start, view: self.view)
        let database = DBManager.shared.database
        let query = DBManager.shared.queryGrammarContent
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.resultsLimit = 500
        operation.recordFetchedBlock = {(records:CKRecord?) in
            guard let record = records else { return }
            if record["unitId"] as! String == unitId{
                self.content.unitId = record["unitId"] as? String
                self.content.constC = record["constC"] as? String
                self.content.constJ = record["constJ"] as? String
                self.content.example = record["example"] as? String
                self.content.words = record["words"] as? String
                let C = self.content.example?.components(separatedBy: "_")[0] ?? ""
                let J = self.content.example?.components(separatedBy: "_")[1] ?? ""
                DispatchQueue.main.async {
                    self.constClabel.text = record["constC"] as? String
                    self.constJlabel.text = record["constJ"] as? String
                    self.exLabel.text = C + "\n" + J
                }
            }
        }
        operation.queryCompletionBlock = {(cursor,error) in
            if error != nil{
                print(error,"queryGmrList error")
                DispatchQueue.main.async {
                    self.loading.activityIndicatorView(flg: .end, view: self.view)
                }
            }else{
                let words = self.content.words?.components(separatedBy: "_") ?? [""]
                self.queryWords(words: words)
            }
        }
        database.add(operation)
    }
    
    
    func queryWords(words:[String]){
        let database = DBManager.shared.database
        let query = DBManager.shared.queryWords
        let operation = CKQueryOperation(query: query)
        operation.recordFetchedBlock = {(records:CKRecord?) in
            guard let record = records else { return }
            for i in words{
                if record["wordId"] as! String == i{
                    let data = Words(wordId: record["wordId"] as! String, Chinese: record["Chinese"] as! String, Japanese: record["Japanese"] as! String)
                    self.words.append(data)
                    DispatchQueue.main.async {
                        self.wordsTableView.reloadData()
                    }
                    break
                }
            }
        }
        operation.queryCompletionBlock = {(cursor,error) in
            if error != nil{
                print(error,"queryWords error")
            }
            DispatchQueue.main.async {
                self.loading.activityIndicatorView(flg: .end, view: self.view)
            }
        }
        database.add(operation)
    }
    
    @objc func wordsVoice(sender:UIButton){
        let exText = words[Int(sender.accessibilityIdentifier!)!].Chinese ?? ""
        voice.speak(text: exText, language: .zh_TW, rate: 0.3, pitch: 1.0)
    }
    


}

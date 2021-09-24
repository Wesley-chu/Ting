//
//  GrammarContent.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/9/16.
//

import Foundation
import UIKit
import CloudKit
import AVFoundation

class GrammarContentController: NaviArrangeViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var wordBt: UIButton!
    @IBOutlet weak var gmrGuideBt: UIButton!
    @IBOutlet weak var gmrTrainingBt: UIButton!
    
    @IBOutlet weak var wordLine: UIView!
    @IBOutlet weak var gmrGuideLine: UIView!
    @IBOutlet weak var gmrTrainingLine: UIView!
    
    @IBOutlet weak var gmrTitleLb: UILabel!
    
    @IBOutlet weak var wordView: WordView!
    @IBOutlet weak var guideView: GuideView!
    @IBOutlet weak var trainingView: TrainingView!
    
    var unitId:String?
    var grammarTitle:String?
    var words = [Words]()
    var content = GrammarContent()
    var loading = ActivityIndicatorView()
    var voice = VoiceManager()
    var naviItemTitle = "単語"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        updateView(type: .word)
        queryGmrGuide(unitId: unitId ?? "")
        
        
        
    }
    
    @IBAction func word(_ sender: UIButton) {
        updateView(type: .word)
        
    }
    
    @IBAction func gmrGuide(_ sender: UIButton) {
        updateView(type: .gmrGuide)
        
        
    }
    
    @IBAction func gmrTraining(_ sender: UIButton) {
        updateView(type: .gmrTrianing)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == wordView.wordTableView{
            return words.count
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell_word", for: indexPath) as? wordTableViewCell
        else { return UITableViewCell() }
        if tableView == wordView.wordTableView{
            cell.wordcLb.text = "　\(words[indexPath.row].Chinese ?? "")"
            cell.wordjLb.text = "　\(words[indexPath.row].Japanese ?? "")"
            cell.voiceBt.accessibilityIdentifier = String(indexPath.row)
            cell.voiceBt.addTarget(self, action: #selector(wordsVoice(sender:)), for: .touchUpInside)
            return cell
        }
        return cell
    }
    
    @objc func wordsVoice(sender:UIButton){
        let exText = words[Int(sender.accessibilityIdentifier!)!].Chinese ?? ""
        voice.speak(text: exText, language: .zh_TW, rate: 0.3, pitch: 1.0)
    }
    
    func updateView(type: contents){
        let yellow = UIColor(hexString: "FFCC00")
        let darkGray = UIColor(hexString: "AEAEB2")
        let lightGray = UIColor(hexString: "F2F2F7")
        switch type {
        case .word:
            wordBt.setTitleColor(yellow, for: .normal)
            wordLine.backgroundColor = yellow
            wordView.isHidden = false
            
            gmrGuideBt.setTitleColor(darkGray, for: .normal)
            gmrGuideLine.backgroundColor = lightGray
            guideView.isHidden = true
            
            gmrTrainingBt.setTitleColor(darkGray, for: .normal)
            gmrTrainingLine.backgroundColor = lightGray
            trainingView.isHidden = true
            
            naviItemTitle = "単語"
            navigationItem.title = naviItemTitle
            
        case .gmrGuide:
            gmrGuideBt.setTitleColor(yellow, for: .normal)
            gmrGuideLine.backgroundColor = yellow
            guideView.isHidden = false
            
            wordBt.setTitleColor(darkGray, for: .normal)
            wordLine.backgroundColor = lightGray
            wordView.isHidden = true
            
            gmrTrainingBt.setTitleColor(darkGray, for: .normal)
            gmrTrainingLine.backgroundColor = lightGray
            trainingView.isHidden = true
            
            naviItemTitle = "文法解説"
            navigationItem.title = naviItemTitle
            
        default:
            gmrTrainingBt.setTitleColor(yellow, for: .normal)
            gmrTrainingLine.backgroundColor = yellow
            trainingView.isHidden = false
            
            wordBt.setTitleColor(darkGray, for: .normal)
            wordLine.backgroundColor = lightGray
            wordView.isHidden = true
            
            gmrGuideBt.setTitleColor(darkGray, for: .normal)
            gmrGuideLine.backgroundColor = lightGray
            guideView.isHidden = true
            
            naviItemTitle = "文法練習"
            navigationItem.title = naviItemTitle
        }
    }
    
    func initView(){
        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = image
        gmrTitleLb.text = "　\(grammarTitle ?? "")"
        wordView.wordTableView.delegate = self
        wordView.wordTableView.dataSource = self
        wordView.wordTableView.register(UINib(nibName: "wordTableViewCell", bundle: nil), forCellReuseIdentifier: "cell_word")
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
                    //self.constClabel.text = record["constC"] as? String
                    //self.constJlabel.text = record["constJ"] as? String
                    //self.exLabel.text = C + "\n" + J
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
                        self.wordView.wordTableView.reloadData()
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
    
}

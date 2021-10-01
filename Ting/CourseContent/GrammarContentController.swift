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

class GrammarContentController: NaviArrangeViewController, UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
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
    
    
    @IBOutlet weak var correctView: UIView!
    @IBOutlet weak var sentenceLb: UILabel!
    
    
    var unitId:String?
    var grammarTitle:String?
    var words = [Words]()
    var content = GrammarContent()
    var loading = ActivityIndicatorView()
    var alert = AlertView()
    var voice = VoiceManager()
    var naviItemTitle = "単語"
    var collectionLayout = LeftAlignedCollectionViewFlowLayout()
    var correctText:String?
    var gmrTraining = GrammarTraining()
    var bottom: NSLayoutConstraint?
    var bottom2: NSLayoutConstraint?
    var strForAnswer = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        updateView(type: .word)
        
        queryGmrGuide(unitId: unitId ?? "")
        queryGmrTraining(unitId: unitId ?? "")
        
        var str = "a b c d"
        print(str.filter{ $0 != " " },"chu1")
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
    
    @IBAction func next(_ sender: UIButton) {
        pullCorrectView(bool: false)
        if gmrTraining.page >= 4{ return }
        
        gmrTraining.page += 1
        trainingView.answerLb.text = ""
        strForAnswer = ""
        correctText = gmrTraining.sentenceC[gmrTraining.page]
        for i in trainingView.trainingCollectionView.visibleCells{
            i.contentView.viewWithTag(1)?.backgroundColor = .clear
            guard let trainLb = i.contentView.viewWithTag(2) as? UILabel
            else { return }
            trainLb.textColor = .cusLightYellow
        }
        gmrTraining.answer.removeAll()
        trainingView.trainingCollectionView.reloadData()
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
    
    @objc func exVoice(){
        guard let exText = content.example?.components(separatedBy: "_")[0] else { return }
        //let AVSpeechUtteranceMinimumSpeechRate: Float
        //let AVSpeechUtteranceDefaultSpeechRate: Float
        //let AVSpeechUtteranceMaximumSpeechRate: Float
        voice.speak(text: exText, language: .zh_TW, rate: 0.4, pitch: 1.0)
    }
    
    @objc func trainingVoice(){
        voice.speak(text: correctText ?? "", language: .zh_TW, rate: 0.4, pitch: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !gmrTraining.item.isEmpty && gmrTraining.item.count <= 5{
            return gmrTraining.item[gmrTraining.page].count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_training", for: indexPath) as! trainingCollectionViewCell
        cell.layer.borderColor = UIColor.cusLightYellow.cgColor
        cell.layer.borderWidth = 1.3
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        if UIScreen.main.bounds.size.height <= 568{
            cell.trainingLb.font = UIFont.boldSystemFont(ofSize: 20)
        }
        
        let item = gmrTraining.item[gmrTraining.page][indexPath.row]
        cell.trainingLb.text = "\(item.word ?? "")　"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let cellView = collectionView.cellForItem(at: indexPath)?.contentView.viewWithTag(1) else { return true }
        guard let cellLb = collectionView.cellForItem(at: indexPath)?.contentView.viewWithTag(2) as? UILabel else { return true }
        let item = gmrTraining.item[gmrTraining.page][indexPath.row]
        
        item.btn = !item.btn!
        cellView.backgroundColor = gmrTraining.setBtnColor(type: .background, bool: item.btn!)
        cellLb.textColor = gmrTraining.setBtnColor(type: .word, bool: item.btn!)
        
        trainingView.answerLb.text! = gmrTraining.checkWord(text: "\(item.word ?? "")　")
        
        strForAnswer = trainingView.answerLb.text!.filter{ $0 != "　" }
        
        return true
    }
    
    
    func updateView(type: contents){
        let yellow = UIColor.cusLightYellow
        let darkGray = UIColor.cusDarkGray
        let lightGray = UIColor.cusLightGray
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
        
        trainingView.trainingCollectionView.delegate = self
        trainingView.trainingCollectionView.dataSource = self
        trainingView.trainingCollectionView.register(UINib(nibName: "trainingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell_training")
        trainingView.trainingCollectionView.collectionViewLayout = collectionLayout
        trainingView.doneBt.layer.cornerRadius = 5
        trainingView.doneBt.layer.masksToBounds = true
        trainingView.voiceVw.layer.cornerRadius = 10
        trainingView.voiceVw.layer.masksToBounds = true
        trainingView.voiceBt.addTarget(self, action: #selector(trainingVoice), for: .touchUpInside)
        trainingView.doneBt.addTarget(self, action: #selector(done), for: .touchUpInside)
        
        correctView.layer.cornerRadius = 10
        correctView.layer.masksToBounds = true
    }
    
    @objc func done(){
        if correctText != strForAnswer {
            self.trainingView.answerLb.textColor = .red
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { [self] in
                trainingView.answerLb.textColor = .black
            }
        }else{
            if gmrTraining.page == 4{
                let message = "\n" + gmrTraining.sentenceJ[gmrTraining.page] + "\n\n" + "練習完了"
                alert.normalAlert(title: "正解！", message: message, okTitle: "確定", cancel: false, contro: self) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            sentenceLb.text! = gmrTraining.sentenceJ[gmrTraining.page]
            pullCorrectView(bool: true)
        }
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
                print("test1")
                print("test1")
                print("test1")
                print("test1")
                DispatchQueue.main.async {
                    self.guideView.constCLb.text = record["constC"] as? String
                    self.guideView.constJLb.text = record["constJ"] as? String
                    self.guideView.exampleCLb.text = C
                    self.guideView.exampleJLb.text = J
                    self.guideView.exampleVoiceBt.addTarget(self, action: #selector(self.exVoice), for: .touchUpInside)
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
    
    func queryGmrTraining(unitId:String){
        let database = DBManager.shared.database
        let query = DBManager.shared.queryGrammarTraining
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.resultsLimit = 500
        operation.recordFetchedBlock = {(records:CKRecord?) in
            guard let record = records else { return }
            if record["unitId"] as! String == unitId{
                self.gmrTraining.unitId = record["unitId"] as? String
                self.gmrTraining.sentence1 = record["sentence1"] as? String
                self.gmrTraining.sentence2 = record["sentence2"] as? String
                self.gmrTraining.sentence3 = record["sentence3"] as? String
                self.gmrTraining.sentence4 = record["sentence4"] as? String
                self.gmrTraining.sentence5 = record["sentence5"] as? String
                self.gmrTraining.handleItem(src: self.gmrTraining)
                self.correctText = self.gmrTraining.sentenceC[self.gmrTraining.page]
                print("test2")
                print("test2")
                print("test2")
                print("test2")
                DispatchQueue.main.async {
                    self.trainingView.trainingCollectionView.reloadData()
                }
            }
        }
        operation.queryCompletionBlock = {(cursor,error) in
            if error != nil{
                print(error,"queryGmrTraining error")
            }
        }
        database.add(operation)
    }
    
    func pullCorrectView(bool:Bool){
        if !bool{
            UIView.animate(withDuration: 0.3) {
                self.bottom = NSLayoutConstraint.init(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: self.correctView, attribute: .bottom, multiplier: 1.0, constant: -270)
                self.bottom2?.isActive = false
                self.bottom?.isActive = true
                self.correctView.frame.origin.y += self.correctView.frame.size.height
            } completion: { _ in
                self.correctView.isHidden = true
            }
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.correctView.isHidden = false
                self.bottom2 = NSLayoutConstraint.init(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: self.correctView, attribute: .bottom, multiplier: 1.0, constant: 30)
                self.bottom?.isActive = false
                self.bottom2?.isActive = true
                self.correctView.frame.origin.y -= self.correctView.frame.size.height
            })
        }
    }
    
}

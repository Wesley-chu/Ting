//
//  GrammarTrainingViewController.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/17.
//

import Foundation
import UIKit
import CloudKit

class GrammarTrainingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var unitId:String?
    var correctText:String?
    var gmrTraining = GrammarTraining()
    
    
    var loading = ActivityIndicatorView()
    var voice = VoiceManager()
    var collectionLayout = LeftAlignedCollectionViewFlowLayout()
    var alert = AlertView()
    
    var bottom: NSLayoutConstraint?
    var bottom2: NSLayoutConstraint?
    
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    @IBOutlet weak var correctView: UIView!
    @IBOutlet weak var sentenceJLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewWillLayoutSubviews() {
        print(self.correctView.frame.origin.y,"chu3")
    }
    
    override func viewDidLayoutSubviews() {
        print(self.correctView.frame.origin.y,"chu4")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(self.correctView.frame.origin.y,"chu2")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(self.correctView.frame.origin.y,"chu5")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.correctView.frame.origin.y,"chu1")
        print(unitId)
        initView()
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        queryGmrTraining(unitId: unitId ?? "")
        itemCollectionView.collectionViewLayout = collectionLayout
        
    }
    
    @IBAction func clickVoice(_ sender: UIButton) {
        voice.speak(text: correctText ?? "", language: .zh_TW, rate: 0.5, pitch: 1.0)
    }
    
    @IBAction func clickGmr(_ sender: UIButton) {
        performSegue(withIdentifier: "segue_gmrGuide", sender: unitId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_gmrGuide"{
            if let toGrammarGuideViewController = segue.destination as? GrammarGuideViewController{
                toGrammarGuideViewController.unitId = sender as? String
            }
        }
    }
    
    
    @IBAction func clickDecide(_ sender: UIButton) {
        if correctText != answerLabel.text! {
            self.answerLabel.textColor = .red
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.answerLabel.textColor = .black
            }
        }else{
            if gmrTraining.page == 4{
                let message = "\n" + gmrTraining.sentenceJ[gmrTraining.page] + "\n\n" + "練習完了"
                alert.normalAlert(title: "正解！", message: message, okTitle: "確定", cancel: false, contro: self) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            sentenceJLabel.text! = gmrTraining.sentenceJ[gmrTraining.page]
            pullCorrectView(bool: true)
        }
    }
    
    @IBAction func next(_ sender: UIButton) {
        pullCorrectView(bool: false)
        if gmrTraining.page >= 4{ return }
        
        gmrTraining.page += 1
        answerLabel.text! = ""
        correctText = gmrTraining.sentenceC[gmrTraining.page]
        for i in itemCollectionView.visibleCells{
            i.contentView.viewWithTag(1)?.backgroundColor = .clear
        }
        gmrTraining.answer.removeAll()
        itemCollectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !gmrTraining.item.isEmpty && gmrTraining.item.count <= 5{
            return gmrTraining.item[gmrTraining.page].count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_gmrTraining", for: indexPath)
        guard let wordsText = cell.viewWithTag(1) as? UILabel else { return cell }
        let item = gmrTraining.item[gmrTraining.page][indexPath.row]
        wordsText.text = item.word ?? ""
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let cellView = collectionView.cellForItem(at: indexPath)?.contentView.viewWithTag(1) as? UILabel else { return true }
        let item = gmrTraining.item[gmrTraining.page][indexPath.row]
        item.btn = !item.btn!
        cellView.backgroundColor = gmrTraining.setBtnColor(type: .background, bool: item.btn!)
        answerLabel.text! = gmrTraining.checkWord(text: item.word ?? "")
        
        return true
    }
    
    
    func queryGmrTraining(unitId:String){
        loading.activityIndicatorView(flg: .start, view: self.view)
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
                print(self.gmrTraining.item[0])
                DispatchQueue.main.async {
                    self.itemCollectionView.reloadData()
                }
            }
        }
        operation.queryCompletionBlock = {(cursor,error) in
            if error != nil{
                print(error,"queryGmrTraining error")
            }
            DispatchQueue.main.async {
                self.loading.activityIndicatorView(flg: .end, view: self.view)
            }
        }
        database.add(operation)
    }
    
    func initView(){
        answerLabel.layer.cornerRadius = 5
        answerLabel.layer.masksToBounds = true
        answerLabel.layer.borderWidth = 2
        answerLabel.layer.borderColor = UIColor.black.cgColor
        
        
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
                self.bottom2 = NSLayoutConstraint.init(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: self.correctView, attribute: .bottom, multiplier: 1.0, constant: 0)
                self.bottom?.isActive = false
                self.bottom2?.isActive = true
                self.correctView.frame.origin.y -= self.correctView.frame.size.height
            })
        }
    }
    
    

}

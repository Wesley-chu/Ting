//
//  GrammarListViewController.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/17.
//

import Foundation
import UIKit
import CloudKit

class GrammarListViewController: NaviArrangeViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var postedLevel:level = .C
    var grammarArr = [[GrammarList]]()
    var grammarTitle:String?
    var listUnitId:String?
    var listArr = [String]()
    
    var loading = ActivityIndicatorView()
    
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        listArr = UserDefaults.standard.array(forKey: "listUnitId") as? [String] ?? [String]()
        listTableView.reloadData()
        print(listArr)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        navigationItem.title = "文法一覧"
        print(postedLevel)
        queryGmrList(level: postedLevel)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grammarArr[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return grammarArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_gmrList")
        let cellViewHeight = cell?.contentView.viewWithTag(1)?.frame.size.height ?? 50
        return cellViewHeight + 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let aView = UIView()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_gmrList")
        let cellViewHeight = cell?.contentView.viewWithTag(1)?.frame.size.height ?? 50
        let width = tableView.frame.size.width - 20
        aView.backgroundColor = UIColor.clear
        
        let bView = UIView()
        bView.frame = CGRect(x: 10, y: 20, width: width, height: cellViewHeight + 5)
        bView.layer.shadowOpacity = 0.1
        bView.layer.shadowRadius = 3
        bView.layer.shadowOffset = CGSize(width: -1.0, height: 2.0)
        bView.backgroundColor = UIColor.white
        aView.addSubview(bView)
        
        let aLabel = UILabel()
        aLabel.text = "　学習ポイント　\(section + 1)"
        aLabel.frame = bView.frame
        aLabel.frame.origin.x = 5
        aLabel.frame.origin.y = 0
        aLabel.frame.size.width = aLabel.frame.size.width - 5
        aLabel.backgroundColor = .clear
        aLabel.font = UIFont.boldSystemFont(ofSize: 18)
        aLabel.clipsToBounds = true
        bView.addSubview(aLabel)
        
        let cView = UIView()
        cView.frame = bView.frame
        cView.frame.origin.x = 0
        cView.frame.origin.y = 0
        cView.frame.size.width = cView.frame.size.width - aLabel.frame.size.width
        cView.backgroundColor = .cusLightYellow
        bView.addSubview(cView)
        
        return aView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_gmrList", for: indexPath)
        guard let view = cell.contentView.viewWithTag(1) else { return cell }
        guard let title = cell.contentView.viewWithTag(2) as? UILabel else { return cell }
        
        guard let check = cell.contentView.viewWithTag(4) else { return cell }
        
        let section = indexPath.section
        let row = indexPath.row
        
        cell.selectionStyle = .none
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: -1.0, height: 3.0)
        
        check.layer.cornerRadius = 14
        check.layer.masksToBounds = true
        check.isHidden = true
        listArr.forEach{
            if $0 == grammarArr[section][row].listUnitId{
                check.isHidden = false
            }
        }

        title.text = "　" + (grammarArr[section][row].grammarTitle ?? "")
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        grammarTitle = grammarArr[section][row].grammarTitle ?? ""
        listUnitId = grammarArr[section][row].listUnitId ?? ""
        performSegue(withIdentifier: "segue_gmrContent", sender: grammarArr[section][row].unitId ?? "")
        
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let cellView = tableView.cellForRow(at: indexPath)?.contentView.viewWithTag(1)
        
        cellView?.backgroundColor = .cusLightYellow
        return true
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cellView = tableView.cellForRow(at: indexPath)?.contentView.viewWithTag(1)
        
        cellView?.backgroundColor = .white
    }
    
    func queryGmrList(level:level){
        loading.activityIndicatorView(flg: .start, view: self.view)
        let database = DBManager.shared.database
        let query = DBManager.shared.queryGrammarList
        query.sortDescriptors = [NSSortDescriptor(key: "levelId", ascending: true),NSSortDescriptor(key: "groupId", ascending: true),NSSortDescriptor(key: "grammarId", ascending: true)]
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.resultsLimit = 500
        operation.recordFetchedBlock = {(records:CKRecord?) in
            guard let record = records else { return }
            if record["levelId"] as! String == level.rawValue{
                let data = GrammarList(levelId: record["levelId"] as! String, groupId: record["groupId"] as! String, grammarId: record["grammarId"] as! String, unitId: record["unitId"] as! String, grammarTitle: record["grammarTitle"] as! String, listUnitId: record.recordID.recordName)

                if self.grammarArr.last?.last?.groupId != data.groupId{
                    self.grammarArr.append([data])
                }else{
                    self.grammarArr[self.grammarArr.count - 1].append(data)
                }
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                }
            }
        }
        operation.queryCompletionBlock = {(cursor,error) in
            if error != nil{
                print(error,"queryGmrList error")
            }
            DispatchQueue.main.async {
                print(self.grammarArr)
                self.loading.activityIndicatorView(flg: .end, view: self.view)
            }
        }
        database.add(operation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_gmrContent" {
            if let toGrammarContentController = segue.destination as? GrammarContentController{
                toGrammarContentController.unitId = sender as? String
                toGrammarContentController.grammarTitle = grammarTitle
                toGrammarContentController.listUnitId = listUnitId
            }
        }
    }
    


}

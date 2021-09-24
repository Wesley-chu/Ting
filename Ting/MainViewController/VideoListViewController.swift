//
//  VideoListViewController.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/8.
//

import Foundation
import UIKit
import CloudKit

class VideoListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var level_1: UIButton!
    @IBOutlet weak var level_2: UIButton!
    @IBOutlet weak var level_3: UIButton!
    @IBOutlet weak var level_4: UIButton!
    @IBOutlet weak var videoTableView: UITableView!
    
    var videoInfoArrData = [VideoInfo]()
    var loading = ActivityIndicatorView()
    var favor = FavoriteButton()
    var random = Random()

    override func viewDidLoad() {
        super.viewDidLoad()
        videoTableView.delegate = self
        videoTableView.dataSource = self
        queryVideos(level: .All)
    }
    
    @IBAction func level(_ sender: UIButton) {
        switch sender {
        case level_1: queryVideos(level: .C)
        case level_2: queryVideos(level: .B)
        case level_3: queryVideos(level: .A)
        case level_4: queryVideos(level: .S)
        default: break
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoInfoArrData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_video", for: indexPath)
        guard let imageView = cell.contentView.viewWithTag(1) as? UIImageView else { return cell }
        guard let title = cell.viewWithTag(2) as? UILabel else { return cell }
        guard let time = cell.viewWithTag(3) as? UILabel else { return cell }
        guard let genre = cell.viewWithTag(4) as? UILabel else { return cell }
        guard let level = cell.viewWithTag(5) as? UILabel else { return cell }
        guard let heartButton = cell.viewWithTag(6) as? UIButton else { return cell }
        //讓網路圖片下載時不會卡卡（異步處理）
        DispatchQueue.global().async {
            let data = NSData.init(contentsOf: NSURL.init(string: self.videoInfoArrData[indexPath.row].imageURL!)! as URL)
            DispatchQueue.main.async {
                let image = UIImage.init(data: data! as Data)
                imageView.image = image
            }
        }
        title.text = Transformation.shared.changeCode(text: videoInfoArrData[indexPath.row].title ?? "")
        time.text = videoInfoArrData[indexPath.row].time ?? ""
        genre.text = videoInfoArrData[indexPath.row].genre ?? ""
        level.text = videoInfoArrData[indexPath.row].level ?? ""
        heartButton.setTitle(videoInfoArrData[indexPath.row].buttonTitle ?? "", for: .normal)
        heartButton.accessibilityIdentifier = "\(indexPath.row)"
        heartButton.addTarget(self, action: #selector(clickFavor(sender:)), for: .touchUpInside)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Account.shared.id != nil {
            let toVideoPlayerViewController = VideoPlayerViewController.instantiate(videoInfoData: videoInfoArrData[indexPath.row])
            self.show(toVideoPlayerViewController, sender: nil)
        }else{
            DispatchQueue.main.async{
                AlertView.shared.normalAlert(title: "無料登録", message: "無料登録でたくさんの学習機能が使えます！", okTitle: "無料登録", cancel: true, contro: self) { _ in
                    let toStartViewController = StartViewController.instantiate()
                    self.show(toStartViewController, sender: nil)
                }
            }
        }
    }
    
    
    @objc func clickFavor(sender:FavoriteButton){
        favor.tapFavoriteButton(sender: sender, arr: &videoInfoArrData)
    }
    
    
    func queryVideos(level:level){
        loading.activityIndicatorView(flg: .start, view: self.view)
        videoInfoArrData.removeAll()
        let database = DBManager.shared.database
        let query = DBManager.shared.queryVideosInfo
        query.sortDescriptors = [NSSortDescriptor(key: "keyinDate", ascending: false)]
        let core = CoreDataManager.shared.coreDataQuery()
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.resultsLimit = 500
        operation.recordFetchedBlock = {(records:CKRecord?) in
            guard let record = records else { return }
            let data = VideoInfo(videoId: record["videoId"] as! String,
                                 title: record["title"] as! String,
                                 subtitle: record["subtitle"] as! String,
                                 imageURL: record["imageURL"] as! String,
                                 time: record["time"] as! String,
                                 level: record["level"] as! String,
                                 genre: record["genre"] as! String,
                                 keyinDate: record["keyinDate"] as! String,
                                 buttonTitle: "💛")
            switch level.rawValue {
            case record["level"] as! String,"":
                data.buttonTitle = self.favor.checkIfFavor(core: core, videoId: data.videoId ?? "")
                self.videoInfoArrData.append(data)
            default: break
            }
            DispatchQueue.main.async {
                self.videoTableView.reloadData()
            }
        }
        operation.queryCompletionBlock = {(cursor,error) in
            if error != nil{
                print(error,"queryVideos error")
            }
            DispatchQueue.main.async {
                self.loading.activityIndicatorView(flg: .end, view: self.view)
            }
        }
        database.add(operation)
    }
    
    
    
    
    
    
    
    


}

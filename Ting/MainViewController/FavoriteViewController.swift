//
//  FavoriteViewController.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/8.
//

import Foundation
import UIKit

class FavoriteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var favorite = [VideoInfo]()
    
    override func viewWillAppear(_ animated: Bool) {
        loadFavorite()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_favor", for: indexPath)
        guard let imageView = cell.contentView.viewWithTag(1) as? UIImageView else { return cell }
        guard let title = cell.viewWithTag(2) as? UILabel else { return cell }
        guard let time = cell.viewWithTag(3) as? UILabel else { return cell }
        guard let genre = cell.viewWithTag(4) as? UILabel else { return cell }
        guard let level = cell.viewWithTag(5) as? UILabel else { return cell }
        let row = indexPath.row
        //讓網路圖片下載時不會卡卡（異步處理）
        DispatchQueue.global().async {
            let data = NSData.init(contentsOf: NSURL.init(string: self.favorite[row].imageURL!)! as URL)
            DispatchQueue.main.async {
                let image = UIImage.init(data: data! as Data)
                imageView.image = image
            }
        }
        title.text = Transformation.shared.changeCode(text: favorite[row].title ?? "")
        time.text = favorite[row].time ?? ""
        genre.text = favorite[row].genre ?? ""
        level.text = favorite[row].level ?? ""
        
        if favorite[row].title!.components(separatedBy: "_").count == 1{
            title.text = Transformation.shared.changeCode(text: favorite[row].title!)
        }else{
            let Chinese = Transformation.shared.changeCode(text: favorite[row].title!.components(separatedBy: "_")[0])
            let Japanese = Transformation.shared.changeCode(text: favorite[row].title!.components(separatedBy: "_")[1])
            title.text = Chinese + "\n" + Japanese
        }
        time.text = Transformation.shared.changeCode(text: favorite[row].time!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toVideoPlayerViewController = VideoPlayerViewController.instantiate(videoInfoData: favorite[indexPath.row])
        self.show(toVideoPlayerViewController, sender: nil)
    }
    
    
    
    
    func loadFavorite(){
        favorite.removeAll()
        let core = CoreDataManager.shared.coreDataQuery()
        for check in core{
            let data = VideoInfo(videoId: check.videoId!,
                                 title: check.title!,
                                 subtitle: check.subtitle!,
                                 imageURL: check.imageURL!,
                                 time: check.time!,
                                 level: check.level!,
                                 genre: check.genre!,
                                 keyinDate: "",
                                 buttonTitle: "")
            favorite.append(data)
            DispatchQueue.main.async { self.favoriteTableView.reloadData() }
        }
        if core.isEmpty{ self.favoriteTableView.reloadData() }

    }
    
    
    

}

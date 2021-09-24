//
//  ViewController.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/6.
//

import UIKit
import WebKit
import AVFoundation
import MediaPlayer
import YoutubePlayer_in_WKWebView

class VideoPlayerViewController: UIViewController,WKYTPlayerViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    static func instantiate(videoInfoData: VideoInfo) -> VideoPlayerViewController{
        let vc = UIStoryboard(name: "VideoPlayer", bundle: nil).instantiateViewController(withIdentifier: "VideoPlayerViewController") as! VideoPlayerViewController
        vc.videoInfoData = videoInfoData
        return vc
    }
    
    
    @IBOutlet weak var playerView: WKYTPlayerView!
    @IBOutlet weak var subtitleTableView: UITableView!
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var repeatView: UIView!
    @IBOutlet weak var playPauseView: UIView!
    
    
    
    var videoInfoData:VideoInfo?
    var subtitleArr = [String]()
    let playerVars = [
        "playsinline" : 1
//        "showinfo" : 0,
//        "controls" : 0,
//        "autohide" : 1,
//        "modestbranding" : 1,
//        "rel" : 0,
//        "autoplay" : 1
        ]
    
    var timer:Timer?
    var ytManager = YTManager()
    var change = Transformation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        playerView.delegate = self
        subtitleTableView.delegate = self
        subtitleTableView.dataSource = self
        
        subtitleArr = videoInfoData?.subtitle?.components(separatedBy: "|") ?? [""]
        
        guard let keyId = videoInfoData?.videoId else { return }
        playerView.load(withVideoId: keyId, playerVars: playerVars)
        
    }
    
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        playerView.playVideo()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subtitleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_player", for: indexPath)
        
        guard let textLabel = cell.viewWithTag(1) as? UILabel
        else { return cell }
        
        let getSubtitle = subtitleArr[indexPath.row]
        let subtitle1 = getSubtitle.components(separatedBy: "_")[1]
        let subtitle2 = getSubtitle.components(separatedBy: "_")[2]
        textLabel.text = subtitle1 + "\n" + subtitle2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if timer != nil{ timer!.invalidate() }
        ytManager.clickToSeconds(playView: playerView, playSubtitle: videoInfoData!, indexPath: indexPath)
        
        let subtitleTime = subtitleArr[indexPath.row].components(separatedBy: "_")[0]
        let perOfTime = Float(subtitleTime)! / Float(change.timeToNum(time: endTime.text!))
        self.timeSlider.setValue(perOfTime, animated: true)
        self.startTime.text = change.numToTime(num: Int(subtitleTime)!)
    }
    
    
    @IBAction func buttonController(_ sender: UIButton) {
        switch sender {
        case playPauseButton:
            print("playPause")
            ytManager.setPlayPause(playView: playerView, sender: playPauseButton)
        case repeatButton:
            print("repeat")
            ytManager.setRepeat(sender: repeatButton)
        case speedButton:
            print("speed")
            ytManager.setSpeed(playView: playerView, sender: speedButton)
        default:
            break
        }
    }
    
    
    //slider fuction
    @IBAction func slideSlider(_ sender: UISlider) {
        //print("slide")
        let changEndTime = Float(change.timeToNum(time: endTime.text!))
        let intEndTime = Int(timeSlider.value * changEndTime)
        let numOfTime = change.numToTime(num: intEndTime)
        startTime.text = numOfTime
    }
    
    @IBAction func pointSlider(_ sender: UISlider) {
        print("point")
        playerView.pauseVideo()
    }
    
    @IBAction func clickSlider(_ sender: UISlider) {
        print("click")
        let numTime = timeSlider.value * Float(change.timeToNum(time: endTime.text!))
        playerView.seek(toSeconds: numTime, allowSeekAhead: true)
        playerView.playVideo()
        ytManager.sliderTimeJumpToThatSubtitle(playSubtitle: videoInfoData!, sliderTime: Int(numTime), subtitleTableView: subtitleTableView)
    }
    //slider fuction
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        switch(state) {
        case WKYTPlayerState.playing:
            print("Video playing")
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { (Timer) in
                self.ytManager.selectSubtitle(playSubtitle: self.videoInfoData!, myWebView: playerView, subtitleTableView: self.subtitleTableView)
                self.playerView.getCurrentTime { (floatValue, error) in
                    if error == nil{
                        let perOfTime = floatValue / Float(self.change.timeToNum(time: self.endTime.text!))
                        self.timeSlider.setValue(perOfTime, animated: true)
                        self.startTime.text = self.change.numToTime(num: Int(floatValue))
                    }else{
                        self.startTime.text = "0:00"
                    }
                    self.ytManager.nowSecond = Int(floatValue)
                    self.ytManager.executeRepeat(playSubtitle: self.videoInfoData!, playView: playerView)
                }
                print(self.ytManager.position)
            })
         
        case WKYTPlayerState.paused:
            print("Video paused")
            if timer != nil{ timer!.invalidate() }
            
        case WKYTPlayerState.unstarted:
            print("Video unstarted")
            
        case WKYTPlayerState.queued:
            print("Video queued")
            
        case WKYTPlayerState.buffering:
            print("Video buffering")
            
        case WKYTPlayerState.ended:
            print("Video ended")
            
        default:
            print("Video others")
            break
        }
    }
    
    func initView(){
        speedView.layer.cornerRadius = 18
        playPauseView.layer.cornerRadius = 20
        repeatView.layer.cornerRadius = 18
        endTime.text = videoInfoData!.time
        ytManager.endSecond = change.timeToNum(time: endTime.text!)
    }
    
    
    
    
    
    
    
    
    


}


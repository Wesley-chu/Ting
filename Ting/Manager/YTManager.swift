//
//  YTManager.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/6.
//

import Foundation
import UIKit
import YoutubePlayer_in_WKWebView
import AVFoundation
import MediaPlayer
import WebKit

class YTManager {
    static let shared = YTManager()
    
    var isRepeat = false
    var speed:Float = 1.0
    var speedSwitch = false //if fasle -, if true +
    var position = 0
    var nowSecond = 0
    var endSecond = 0
    var savePoint = 0
    
    let pauseImg = UIImage(named:"pause")!
    let playImg = UIImage(named:"play")!
    let isRepeatImg = UIImage(named: "repeat")!
    let noRepeatImg = UIImage(named: "noRepeat")!
    
    func selectSubtitle(playSubtitle: VideoInfo, myWebView:WKYTPlayerView, subtitleTableView:UITableView){
        myWebView.getCurrentTime { (floatValue, error) in
            if error == nil{
                var count = 0
                let arr = playSubtitle.subtitle?.components(separatedBy: "|") ?? [""]
                for i in arr{
                    if Int(i.components(separatedBy: "_")[0]) == Int(floatValue){
                        subtitleTableView.scrollToRow(at: IndexPath(row: count, section: 0), at: .middle, animated: true)
                        subtitleTableView.selectRow(at: IndexPath(row: count, section: 0), animated: true, scrollPosition: .none)
                        self.position = count
                    }
                    count += 1
                }
            }
        }
    }
    
    func clickToSeconds(playView:WKYTPlayerView, playSubtitle:VideoInfo, indexPath: IndexPath){
        let arr = playSubtitle.subtitle?.components(separatedBy: "|") ?? [""]
        for countArr in 0 ... (arr.count - 1){
            if countArr == indexPath.row{
                if let seconds = Float(arr[countArr].components(separatedBy: "_")[0]){
                    playView.seek(toSeconds: seconds, allowSeekAhead: true)
                    break
                }
            }
        }
    }
    
    
    func sliderTimeJumpToThatSubtitle(playSubtitle:VideoInfo, sliderTime:Int, subtitleTableView:UITableView){
        var count = 0
        let arr = playSubtitle.subtitle?.components(separatedBy: "|") ?? [""]
        for i in arr{
            //該当字幕の開始時間はスライダータイムより大きい
            if Int(i.components(separatedBy: "_")[0])! > sliderTime{
                if count != 0{// not first subtitle
                    subtitleTableView.scrollToRow(at: IndexPath(row: count - 1, section: 0), at: .middle, animated: true)
                    subtitleTableView.selectRow(at: IndexPath(row: count - 1, section: 0), animated: true, scrollPosition: .none)
                }else{ //first subtitle
                    subtitleTableView.scrollToRow(at: IndexPath(row: count, section: 0), at: .middle, animated: true)
                    subtitleTableView.selectRow(at: IndexPath(row: count, section: 0), animated: true, scrollPosition: .none)
                }
                break
            }else if Int((arr.last?.components(separatedBy: "_")[0])!)! < sliderTime{
                subtitleTableView.scrollToRow(at: IndexPath(row: count, section: 0), at: .middle, animated: true)
                subtitleTableView.selectRow(at: IndexPath(row: count, section: 0), animated: true, scrollPosition: .none)
            }
            count += 1
        }
    }
    
    func setPlayPause(playView:WKYTPlayerView,sender:UIButton){
        playView.getPlayerState { (state, error) in
            if error == nil{
                switch state {
                case WKYTPlayerState.playing:
                    sender.setImage(self.playImg, for: .normal)
                    playView.pauseVideo()
                case WKYTPlayerState.paused:
                    sender.setImage(self.pauseImg, for: .normal)
                    playView.playVideo()
                case WKYTPlayerState.queued:
                    sender.setImage(self.pauseImg, for: .normal)
                    playView.playVideo()
                default: break
                }
            }else{
                sender.setImage(self.playImg, for: .normal)
                playView.stopVideo()
            }
        }
    }
    
    func setRepeat(sender:UIButton){
        switch isRepeat {
        case false:
            savePoint = position + 1
            sender.setImage(isRepeatImg, for: .normal)
        default:
            sender.setImage(noRepeatImg, for: .normal)
        }
        isRepeat = !isRepeat
    }
    
    func executeRepeat(playSubtitle: VideoInfo, playView:WKYTPlayerView){
        if isRepeat{
            print("execute")
            let arr = playSubtitle.subtitle?.components(separatedBy: "|") ?? [""]
            if arr[position] != arr.last{
                if let second = Float(arr[savePoint].components(separatedBy: "_")[0]){
                    if nowSecond >= Int(second){
                        if let second_2 = Float(arr[savePoint -  1].components(separatedBy: "_")[0]){
                            playView.seek(toSeconds: second_2, allowSeekAhead: true)
                        }
                    }
                    print(nowSecond,second)
                }
            }else{
                if nowSecond == endSecond{
                    if let second = Float(arr.last!.components(separatedBy: "_")[0]){
                        playView.seek(toSeconds: second, allowSeekAhead: true)
                    }
                }
            }
        }
    }
    
    func setSpeed(playView:WKYTPlayerView,sender:UIButton){
        switch speed {
        case 0.25:
            speedSwitch = true
            speed += 0.25
        case 2.0:
            speedSwitch = false
            speed -= 0.25
        default:
            if speedSwitch == true{
                speed += 0.25
            }else{
                speed -= 0.25
            }
        }
        sender.setTitle(String(speed), for: .normal)
        playView.setPlaybackRate(speed)
    }
    
    
}

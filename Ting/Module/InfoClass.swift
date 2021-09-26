//
//  videoInfo.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/6.
//

import Foundation
import UIKit

class VideoInfo {
    var videoId:String?
    var title:String?
    var subtitle:String?
    var imageURL:String?
    var time:String?
    var keyinDate:String?
    var level:String?
    var genre:String?
    var buttonTitle:String?
    
    init(videoId:String,title:String,subtitle:String,imageURL:String,
         time:String,level:String,genre:String,keyinDate:String,buttonTitle:String) {
        self.videoId = videoId
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.time = time
        self.level = level
        self.genre = genre
        self.keyinDate = keyinDate
        self.buttonTitle = buttonTitle
    }
}

class GrammarList {
    var levelId:String?
    var groupId:String?
    var grammarId:String?
    var unitId:String?
    var grammarTitle:String?
    
    init(levelId:String, groupId:String, grammarId:String, unitId:String, grammarTitle:String) {
        self.levelId = levelId
        self.groupId = groupId
        self.grammarId = grammarId
        self.unitId = unitId
        self.grammarTitle = grammarTitle
    }
    
}

class GrammarContent {
    var unitId:String?
    var constC:String?
    var constJ:String?
    var example:String?
    var words:String?
}

class Words {
    var wordId:String?
    var Chinese:String?
    var Japanese:String?
    init(wordId:String,Chinese:String,Japanese:String) {
        self.wordId = wordId
        self.Chinese = Chinese
        self.Japanese = Japanese
    }
}

class GrammarTraining {
    var unitId:String?
    var sentence1:String?
    var sentence2:String?
    var sentence3:String?
    var sentence4:String?
    var sentence5:String?
    
    var page = 0
    var sentenceC = [String]()
    var sentenceJ = [String]()
    var item = [[switchContent]]()
    var answer = [String]()
    
    
    func handleItem(src:GrammarTraining){
        let s1 = src.sentence1?.components(separatedBy: "|") ?? [""]
        let s2 = src.sentence2?.components(separatedBy: "|") ?? [""]
        let s3 = src.sentence3?.components(separatedBy: "|") ?? [""]
        let s4 = src.sentence4?.components(separatedBy: "|") ?? [""]
        let s5 = src.sentence5?.components(separatedBy: "|") ?? [""]
        
        var arr1 = s1[0].components(separatedBy: "_")
        var arr2 = s2[0].components(separatedBy: "_")
        var arr3 = s3[0].components(separatedBy: "_")
        var arr4 = s4[0].components(separatedBy: "_")
        var arr5 = s5[0].components(separatedBy: "_")
        
        sentenceC.append(arr1.reduce("") { $0 + $1 })
        sentenceC.append(arr2.reduce("") { $0 + $1 })
        sentenceC.append(arr3.reduce("") { $0 + $1 })
        sentenceC.append(arr4.reduce("") { $0 + $1 })
        sentenceC.append(arr5.reduce("") { $0 + $1 })
        
        sentenceJ.append(s1[1])
        sentenceJ.append(s2[1])
        sentenceJ.append(s3[1])
        sentenceJ.append(s4[1])
        sentenceJ.append(s5[1])
        
        var ss1 = [switchContent]()
        var ss2 = [switchContent]()
        var ss3 = [switchContent]()
        var ss4 = [switchContent]()
        var ss5 = [switchContent]()
        
        arr1.shuffle()
        arr2.shuffle()
        arr3.shuffle()
        arr4.shuffle()
        arr5.shuffle()
        
        func handleItemArr(arr:Array<String>) -> [switchContent]{
            var SCArr = [switchContent]()
            var count = 0
            for i in arr{
                let SC = switchContent()
                SC.word = i
                SC.btn = false
                SC.id = String(count)
                SCArr.append(SC)
                count += 1
            }
            return SCArr
        }
        
        ss1 = handleItemArr(arr: arr1)
        ss2 = handleItemArr(arr: arr2)
        ss3 = handleItemArr(arr: arr3)
        ss4 = handleItemArr(arr: arr4)
        ss5 = handleItemArr(arr: arr5)
        
        item.append(ss1)
        item.append(ss2)
        item.append(ss3)
        item.append(ss4)
        item.append(ss5)
        
        
        
    }
    
    func setBtnColor(type:colorType ,bool:Bool) -> UIColor{
        switch bool {
        case false:
            
            switch type {
            case .word:
                return .cusLightYellow
            default:
                return .clear
            }
            
        default:
            
            switch type {
            case .word:
                return .white
            default:
                return UIColor.cusLightYellow
            }
            
        }
    }
    
    func checkWord(text:String) -> String{
        var count = 0
        var check = false
        var str = ""
        for i in answer{
            if text == i {
                answer.remove(at: count)
                check = true
                break
            }
            count += 1
        }
        if check == false{
            answer.append(text)
        }
        for j in answer{
            str += j
        }
        return str
    }
    
    
}

class switchContent {
    var id:String?
    var word:String?
    var btn:Bool?
}



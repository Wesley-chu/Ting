//
//  enum.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/6.
//

import Foundation

enum recordType: String {
    case usersInfo = "usersInfo"
    case videosInfo = "videosInfo"
    case grammarList = "grammarList"
    case grammarContent = "grammarContent"
    case words = "words"
    case grammarTraining = "grammarTraining"
}

enum level : String {
    case C = "C"
    case B = "B"
    case A = "A"
    case S = "S"
    case All = ""
}

enum loading {
    case start
    case end
}

enum coreStyle{
    case save
    case delete
}

enum language:String{
    case zh_TW = "zh-TW"
    case zh_CN = "zh-CN"
}

enum contents {
    case word
    case gmrGuide
    case gmrTrianing
}



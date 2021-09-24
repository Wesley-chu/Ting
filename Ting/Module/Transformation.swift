//
//  Transformation.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/6.
//

import Foundation

class Transformation {
    static let shared = Transformation()
    
    func changeTimeForm(time:String) -> String{
        var H = false
        var M = false
        var S = false
        var change = time
        for checkTime in time{
            if String(checkTime) == "H"{ H = true }
            if String(checkTime) == "M"{ M = true }
            if String(checkTime) == "S"{ S = true }
        }
        if H == true && M == true && S == true{
            change = change.replacingOccurrences(of: "H", with: ":")
            change = change.replacingOccurrences(of: "M", with: ":")
            change = change.replacingOccurrences(of: "S", with: "")
        }else if H == true && M == true && S == false{
            change = change.replacingOccurrences(of: "H", with: ":")
            change = change.replacingOccurrences(of: "M", with: ":00")
        }else if H == true && M == false && S == false{
            change = change.replacingOccurrences(of: "H", with: ":00:00")
        }else if H == true && M == false && S == true{
            change = change.replacingOccurrences(of: "H", with: ":00:")
            change = change.replacingOccurrences(of: "S", with: "")
        }else if H == false && M == true && S == true{
            change = change.replacingOccurrences(of: "M", with: ":")
            change = change.replacingOccurrences(of: "S", with: "")
        }else if H == false && M == true && S == false{
            change = change.replacingOccurrences(of: "M", with: ":00")
        }else if H == false && M == false && S == true{
            change = change.replacingOccurrences(of: "S", with: "")
            change = "0:\(change)"
        }
        var component = change.components(separatedBy: ":")
        if component.count == 2 && component[0] != "0" && component[1] != "00"{
            if Int(component[1])! < 10{ component[1] = "0\(component[1])" }
            change = component[0] + ":" + component[1]
        }else if component.count == 3 && component[0] != "0" && component[1] != "00"{
            if Int(component[1])! < 10{ component[1] = "0\(component[1])" }
            if Int(component[2])! < 10{ component[2] = "0\(component[2])" }
            change = component[0] + ":" + component[1] + ":" + component[2]
        }
        return change
    }
    
    
    func numToTime(num:Int) -> String{
        let t1 = num / 60
        let t2 = num % 60
        var st2 = ""
        if t2 < 10{
            st2 = "0\(t2)"
        }else{
            st2 = "\(t2)"
        }
        return "\(t1):\(st2)"
    }
    

    func timeToNum(time:String) -> Int{
        var total = 0
        let component = time.components(separatedBy: ":")
        if component.count == 3{
            total += Int(component[0])! * 60 * 60
            total += Int(component[1])! * 60
            total += Int(component[2])!
        }else if component.count == 2{
            total += Int(component[0])! * 60
            total += Int(component[1])!
        }
        return total
    }
    
    
    func dayToDay(day:Int) -> String{
        if day == 1 || day == 2 || day == 3 || day == 4 || day == 5 || day == 6 || day == 7 || day == 8 || day == 9{ return "0\(day)" }else{ return "\(day)" }
    }
    
    
    func changeCode(text:String)->String{
        do{
            let encodedData = text.data(using: String.Encoding.utf8)
            let attributedString = try NSAttributedString(data: encodedData!,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding:String.Encoding.utf8.rawValue],documentAttributes: nil)
            return attributedString.string
        }catch{
            return "\(debugPrint(error.localizedDescription))"
            
        }
    }
    
    
    
}

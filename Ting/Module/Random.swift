//
//  Random.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/7/10.
//

import Foundation

class Random {
    
    func random(length:Int) -> String {
        let letters : String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var str = ""
        for _ in 0 ..< length{
            str += String(letters.randomElement()!)
        }
        return str
    }
    
    
    
    
    
}


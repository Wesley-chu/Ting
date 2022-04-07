//
//  File.swift
//  Ting
//
//  Created by 朱偉綸 on 2022/3/30.
//

import Foundation
import AudioToolbox

class EBMuteDetector: NSObject{
    
    static let shared: EBMuteDetector = {
        let path = Bundle.main.path(forResource: "mute", ofType: "aif")
        let url = URL(fileURLWithPath: path!)
        var detector = EBMuteDetector()
        let status = AudioServicesCreateSystemSoundID(url as CFURL, &detector.soundID)
        if status == kAudioServicesNoError {
            AudioServicesAddSystemSoundCompletion(detector.soundID, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue, completionProc, Unmanaged.passUnretained(detector).toOpaque())
            var yes = 1
            AudioServicesSetProperty(kAudioServicesPropertyIsUISound, UInt32(MemoryLayout<SystemSoundID>.size), &detector.soundID, UInt32(MemoryLayout<Bool>.size), &yes)
        }else{
            detector.soundID = .max
        }
        return detector
    }()
    
    static let completionProc: AudioServicesSystemSoundCompletionProc = {(soundID: SystemSoundID, p: UnsafeMutableRawPointer?) in
        let elapsed = Date.timeIntervalSinceReferenceDate - shared.interval
        let isMute = elapsed < 0.1
        shared.completion(isMute)
    }
    
    var completion = { (mute: Bool) in }
    
    var soundID: SystemSoundID = 1312
    
    var interval: TimeInterval = 1
    
    func detect(block: @escaping (Bool) -> ()) {
        interval = NSDate.timeIntervalSinceReferenceDate
        AudioServicesPlaySystemSound(soundID)
        completion = block
    }
    
    deinit {
        if (soundID != .max) {
            AudioServicesRemoveSystemSoundCompletion(soundID)
            AudioServicesDisposeSystemSoundID(soundID)
        }
    }
    
}

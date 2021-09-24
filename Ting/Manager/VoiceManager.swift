//
//  VoiceManager.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/6/21.
//

import Foundation
import AVFoundation

class VoiceManager {
    let synthesizer = AVSpeechSynthesizer()
    
    func speak(text:String, language:language, rate:Float, pitch:Float){
        let utterance = AVSpeechUtterance.init(string: text)
        let voice = AVSpeechSynthesisVoice.init(language: language.rawValue)
        utterance.voice = voice
        utterance.rate = rate
        utterance.pitchMultiplier = pitch
        synthesizer.speak(utterance)
    }
    
}

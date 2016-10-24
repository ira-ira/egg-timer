//
//  AudioUtil.swift
//  egg timer
//
//  Created by infuntis on 24.10.16.
//  Copyright © 2016 gala. All rights reserved.
//

import Foundation
import AVFoundation


class AudioUtil {
    
    open var soundEffectPlayer: AVAudioPlayer?
    
    open class func sharedInstance() -> AudioUtil {
        return AudioUtilInstance
    }
    
    open func stopSoundEffect(){
        if let player = soundEffectPlayer {
            if player.isPlaying {
                player.stop()
            }
        }
    }
    open func playSoundEffect(_ filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        if (url == nil) {
            print("Could not find file: \(filename)")
            return
        }
        
        var error: NSError? = nil
        do {
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url!)
        } catch let error1 as NSError {
            error = error1
            soundEffectPlayer = nil
        }
        if let player = soundEffectPlayer {
            player.numberOfLoops = 0
            player.prepareToPlay()
            player.play()
        } else {
            print("Could not create audio player: \(error!)")
        }
    }
}

private let AudioUtilInstance = AudioUtil()

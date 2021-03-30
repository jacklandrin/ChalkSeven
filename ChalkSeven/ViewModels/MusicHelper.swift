//
//  MusicHelper.swift
//  ChalkBallForMac
//
//  Created by jack on 2021/3/29.
//  Copyright © 2021 jack. All rights reserved.
//

import AVFoundation

class MusicHelper {
    var music: AVAudioPlayer!
    static let sharedHelper = MusicHelper()
    
    func playBackgroundMusic() {
        if let musicURL = Bundle.main.path(forResource: "chalk7", ofType: "m4a") {
            if let audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicURL)) {
                music = audioPlayer
                music.numberOfLoops = -1
                music.play()
            }
        }
    }
    
    func stopBackgroundMusic() {
        if music.isPlaying {
            music.stop()
        }
    }
    
}

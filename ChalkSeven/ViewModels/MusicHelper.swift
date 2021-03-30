//
//  MusicHelper.swift
//  ChalkBallForMac
//
//  Created by jack on 2021/3/29.
//  Copyright © 2021 jack. All rights reserved.
//

import AVFoundation

class MusicHelper : ObservableObject {
    var backgroundPlayer: AVAudioPlayer!
    var effectSoundPlayers: [AVAudioPlayer] = [AVAudioPlayer(), AVAudioPlayer(),AVAudioPlayer()]
    
    static let sharedHelper = MusicHelper()
    @UserDefaultValue(key: "canPlayBGM", defaultValue: true)
    var canPlayBGM : Bool
    {
        willSet {
            objectWillChange.send()
        }
        didSet {
            canPlayBGM ? MusicHelper.sharedHelper.playBackgroundMusic() : MusicHelper.sharedHelper.stopBackgroundMusic()
        }
    }
    
    @UserDefaultValue(key: "canPlayEM", defaultValue: true)
    var canPlayEM : Bool
    {
        willSet {
            objectWillChange.send()
        }
    }
    
    func playBackgroundMusic() {
        guard self.canPlayBGM else {
            return
        }
        if let musicURL = Bundle.main.path(forResource: "chalk7", ofType: "m4a") {
            if let audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicURL)) {
                backgroundPlayer = audioPlayer
                backgroundPlayer.numberOfLoops = -1
                backgroundPlayer.play()
            }
        }
    }
    
    func stopBackgroundMusic() {
        guard let playingMusic = backgroundPlayer else {
            return
        }
        if playingMusic.isPlaying {
            playingMusic.stop()
        }
    }
    
    func playSound(name:String, type:String) {
        guard self.canPlayEM else {
            return
        }
        if let musicURL = Bundle.main.path(forResource: name, ofType: type) {
            if let audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicURL)) {
                for index in effectSoundPlayers.indices {
                    if !effectSoundPlayers[index].isPlaying {
                        effectSoundPlayers[index] = audioPlayer
                        effectSoundPlayers[index].numberOfLoops = 0
                        effectSoundPlayers[index].play()
                        break
                    }
                }
                
            }
        }
    }
    
}

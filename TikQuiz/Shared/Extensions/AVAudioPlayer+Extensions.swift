//
//  AVAudioPlayer+Extensions.swift
//  TikQuiz
//
//  Created by István Kreisz on 8/15/22.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

extension AVAudioPlayer {
    static func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("ERROR")
            }
        }
    }
}

//

//  PlaySoundsViewController.swift

//  Pitch Perfect

//

//  Created by Gary Wang on 3/6/15.

//  Copyright (c) 2015 self. All rights reserved.

//



import UIKit

import AVFoundation



class PlaySoundsViewController: UIViewController {
    
    //define global variables
    
    var audioPlayer : AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var audioPlayer2:AVAudioPlayer!
    var reverbPlayers:[AVAudioPlayer] = []
    let N:Int = 10
    
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //get recording audio from previous page
        //init audioPlayer, audioPlayer2, audioEngine and audioFile
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl    ,
            error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl,
            error: nil)
        
        //prepare different audioPlayer for reverb and echo
        let bundle = NSBundle.mainBundle()
        var wavURL = receivedAudio.filePathUrl
        audioPlayer2 = AVAudioPlayer(contentsOfURL: wavURL,
            fileTypeHint: "wav",
            error: nil)
       
        for i in 0...N {
            var temp = AVAudioPlayer(contentsOfURL: wavURL,
                fileTypeHint: "wav",
                error: nil)
            reverbPlayers.append(temp)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func stopAudioSoundAll()
        
    {   //stop all audio palyers which include slow, fast ,high pitch , low pitch, reverb and echo to prevent sound overlap
        if audioEngine.running  {
            audioEngine.stop()
            audioEngine.reset()
        }
        
        if audioPlayer.playing {
            audioPlayer.stop()
        }
        //stop echo player
        if audioPlayer2.playing {
            audioPlayer2.stop()
        }
        //stop reverb player
        for i in 0...N {
            var reverbplayer:AVAudioPlayer = reverbPlayers[i]
            if reverbplayer.playing {
                reverbplayer.stop()
            }
        }
    }
    

    
    @IBAction func playSlowAudio(sender: UIButton) {
        //stop and reset to prevent sound overlap
        stopAudioSoundAll()
        //play audio in slow speed sound
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    
    
    @IBAction func playFastAudio(sender: UIButton) {
        //stop and reset to prevent sound overlap
        stopAudioSoundAll()
        //play audio in fast speed sound
        audioPlayer.rate = 1.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    

    @IBAction func stopAudio(sender: UIButton) {
        //stop all audio player sound
        stopAudioSoundAll()
    }
    
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        //play audio with high pitch like Chipmunk sound
        stopAudioSoundAll()
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch (pitch: Float){
        //this funcion use input variable to control the pitch sound in high or low
        stopAudioSoundAll()
        
        var audioPlayNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayNode, to: changePitchEffect,
            format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode,
            format: nil)
        audioPlayNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayNode.play()
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        //play audio with low pitch like Darthvader sound
         stopAudioSoundAll()
         playAudioWithVariablePitch(250)
        }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        //play audio with echo sound
        stopAudioSoundAll()
        audioPlayer.currentTime = 0;
        audioPlayer.play()
        
        let delay:NSTimeInterval = 0.1
        var playtime:NSTimeInterval
        playtime = audioPlayer2.deviceCurrentTime + delay
        audioPlayer2.stop()
        audioPlayer2.currentTime = 0
        audioPlayer2.volume = 0.8;
        audioPlayer2.playAtTime(playtime)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        //stop and reset to prevent sound overlap
        stopAudioSoundAll()
        //play audio with reverb sound
        let delay:NSTimeInterval = 0.02
        for i in 0...N {
            var curDelay:NSTimeInterval = delay*NSTimeInterval(i)
            var player:AVAudioPlayer = reverbPlayers[i]
            var exponent:Double = -Double(i)/Double(N/2)
            var volume = Float(pow(Double(M_E), exponent))
            player.volume = volume
            player.playAtTime(player.deviceCurrentTime + curDelay)
        }
    }
    
    
   
    
    
    
    
    
    
}


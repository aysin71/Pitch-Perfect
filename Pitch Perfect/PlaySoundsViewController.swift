//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Aysin Kuran on 9/19/15.
//  Copyright © 2015 Aysin Kuran. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
          try audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        } catch {
         print("no audio to play")
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker)
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        
        audioPlayer.enableRate=true
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func playSlowAudio(sender: UIButton) {
        playRecordedAudio(0.5, pitch: 0, echo: 0, reverb: 0)

    }
    
    @IBAction func playFastAudion(sender: UIButton) {
        playRecordedAudio(2, pitch: 0, echo: 0, reverb: 0)

    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playRecordedAudio(1, pitch: 1000, echo: 0, reverb: 0)

    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playRecordedAudio(1, pitch: -1000, echo: 0, reverb: 0)

    }
    
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playRecordedAudio(1, pitch: 0, echo: 30, reverb: 0)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playRecordedAudio(1, pitch: 0, echo: 0, reverb: 100)
    }
    
    
    func playRecordedAudio(rate: Float,  pitch: Float, echo: Float, reverb: Float)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //set Rate
        let changeRateEffect = AVAudioUnitVarispeed()
        changeRateEffect.rate = rate
        audioEngine.attachNode(changeRateEffect)
        
        //set Pitch
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // Set Echo
        
        let changeEchoEffect = AVAudioUnitDelay()
        changeEchoEffect.delayTime = NSTimeInterval(echo)
        audioEngine.attachNode(changeEchoEffect)
        
        //Setting the reverb effect
        let changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall2)
        changeReverbEffect.wetDryMix = reverb
        audioEngine.attachNode(changeReverbEffect)
        
        //connecting effects
        audioEngine.connect(audioPlayerNode, to: changeRateEffect, format: nil)
        audioEngine.connect(changeRateEffect, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: changeEchoEffect, format: nil)
        audioEngine.connect(changeEchoEffect, to: audioEngine.outputNode, format: nil)
        
        //setting the file to be played to the recorded file
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        //play the Recorded File
        audioPlayerNode.play()

    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()

    }

}

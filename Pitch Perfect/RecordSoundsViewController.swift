//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Aysin Kuran on 9/18/15.
//  Copyright (c) 2015 Aysin Kuran. All rights reserved.
//

import AVFoundation

import UIKit


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    

    @IBOutlet weak var RecordButton: UIButton!
    
    @IBOutlet weak var RecordLabel: UILabel!
    
    @IBOutlet weak var StopButton: UIButton!
    
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        RecordLabel.hidden = true
        StopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func StartRecording(sender: UIButton) {
        RecordLabel.hidden = false
        StopButton.hidden = false
        RecordButton.enabled = false
        //Record User's Voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        //let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        //setup Audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        //Initialize and prepare the recorder
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            //Step 1 - Save the recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            //TODO: Step 2 - Move to the next scene aka perform a segue
            self.performSegueWithIdentifier("StopRecording", sender: recordedAudio)
           
        }else{
            print("Recording was not successful")
            RecordButton.enabled = true
            StopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StopRecording" {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }

    @IBAction func StopRecording(sender: UIButton) {
        RecordLabel.hidden = true
        StopButton.hidden = true
        RecordButton.enabled = true
        // stop Recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)


    }
}


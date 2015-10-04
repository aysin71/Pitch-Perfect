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
    
    //outlets
    @IBOutlet weak var RecordButton: UIButton!
    
    @IBOutlet var TapLabel: UILabel!
    
    @IBOutlet weak var StopResumeButton: UIButton!
    
    
    @IBOutlet weak var StopButton: UIButton!
    
    //Global variable declarations
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the AudioFile name and path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //start session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        //initialize
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        
        //delegate
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        //recording preparation finished. 
        //This part is removed from StartRecording function to reuse it
        }
    
    override func viewWillAppear(animated: Bool) {
        //set initialscreen labels and buttons
        TapLabel.hidden = false
        TapLabel.text = "Tap to Record"
        StopButton.hidden = true
        StopResumeButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func StartRecording(sender: UIButton) {
        //set screen labels and buttons
        TapLabel.text = "Recording in progress"
        StopButton.hidden = false
        StopResumeButton.hidden = false
        RecordButton.enabled = false
        
        //start recording
        audioRecorder.record()
    }
    
    @IBAction func PauseRecording(sender: UIButton) {
        //set screen labels and buttons
        StopResumeButton.hidden = true
        RecordButton.enabled = true
        TapLabel.text = "Tap to Continue Recording"
        
        //pause recording
        audioRecorder.pause()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    @IBAction func StopRecording(sender: UIButton) {
        //set screen labels and buttons
        StopButton.hidden = true
        StopResumeButton.hidden = true
        RecordButton.enabled = true
        
        //stop recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        //function to determine when recording is finished
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("StopRecording", sender: recordedAudio)
            }
            else{
            print("Recording was not successful")
            RecordButton.enabled = true
            StopButton.hidden = true
            StopResumeButton.hidden = true
            }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //navigate to next screen if StopButton is pressed
        if segue.identifier == "StopRecording" {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }

}

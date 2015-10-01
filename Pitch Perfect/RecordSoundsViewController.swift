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
    
    @IBOutlet weak var TapLabel: UILabel!
    @IBOutlet weak var RecordLabel: UILabel!
    
    @IBOutlet weak var StopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        TapLabel.hidden = false
        RecordLabel.hidden = true
        StopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func StartRecording(sender: UIButton) {
        TapLabel.hidden = true
        RecordLabel.hidden = false
        StopButton.hidden = false
        RecordButton.enabled = false

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)

        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            var recordedAudioinit = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            //recordedAudio.filePathUrl = recorder.url
            //recordedAudio.title = recorder.url.lastPathComponent!
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
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
}


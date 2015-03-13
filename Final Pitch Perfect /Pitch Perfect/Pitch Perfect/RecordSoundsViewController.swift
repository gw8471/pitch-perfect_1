//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Gary Wang on 3/6/15.
//  Copyright (c) 2015 self. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController ,AVAudioRecorderDelegate  {
    //define outlet
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    //define global variable
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        //the first screen show all appear components and hide stop button on the screen
        stopButton.hidden = true
        recordButton.enabled = true
        pauseButton.hidden = true
        recordingInProgress.hidden = false
        recordingInProgress.text = "Tap to Record"
    }

    @IBAction func recordAudio(sender: UIButton) {
        //show text recording in progress on the screen
        recordingInProgress.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        pauseButton.hidden = false
        recordingInProgress.text = "Recording..."
        //record user voice
        println("in recordAudio")
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        //setup wave file format and path
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord,
            error: nil)
        //use delegate  to make record audio voice
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil,
            error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
        //init recordedAudio and setup property for  recordedAudio.filePathUrl and recordedAudio.title.
        //save audio info into system with filePathUrl and title
            
            recordedAudio = RecordedAudio(filePathUrl : recorder.url
                ,title : recorder.url.lastPathComponent)

        //move the next page
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else
        {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //invoke Segue
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
          
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        //make audio playt stop
        recordingInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    @IBAction func pauseAudio(sender: UIButton) {
        //pause recording show stop button if re-click then it start continue re-recording and hide stop button
        
        if audioRecorder.recording {
                recordingInProgress.text = "Pause..."
                stopButton.hidden = true
                audioRecorder.pause()
        }
        else {
                recordingInProgress.text = "Recording..."
                stopButton.hidden = false
                audioRecorder.record()
        }
      
        
    }
}


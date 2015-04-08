//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Richard Hall on 03/04/2015.
//  Copyright (c) 2015 RH. All rights reserved.
//

import UIKit
import AVFoundation

// Note in this class the AVAudioRecorderDelegate declaration here (and audioRecorder.delegate = self below) 
//      This delegate characteristic is used and is necessary to delgate method audioRecorderDidFinishRecording to this class RSVC
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // Outlet buttons for Record View Controller - enables their animation, such as hiding
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tapToRecordButton: UILabel!
    @IBOutlet weak var tapToStopRecordbuttonLabel: UILabel!

    // AV Audio Recorder - Key object for Audio Recorder and its methods
    var audioRecorder:AVAudioRecorder!
    // Variable storing recorded audio
    var recordedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Key button animation and reseting
        stopButton.hidden = true
        recordButton.enabled = true
        tapToRecordButton.hidden = false
        tapToStopRecordbuttonLabel.hidden = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        // Method for actual Audio recording
        // For example, record the user's voice
        
        // Key button animation and reseting
        stopButton.hidden = false
        recordingInProgress.hidden = false
        recordButton.enabled = false
        tapToRecordButton.hidden = true
        tapToStopRecordbuttonLabel.hidden = false
        
 
        // Set the path and other characteristics (name, date, type, etc) for file to save Audio to
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)

        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self               // Enables 'transfer' of data to other view controller - this class RSVC is delegate of audioRecorder
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord()
        audioRecorder.record()                      // Finally do recording
    }

    // The next method is invoked when the audio recording has finished - in turn an action from the stop button
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
       if (flag) {
            // Save the recorded audio
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
        
            // Move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio) // recordedAudio is the object that actually intiates the segue
       } else {
        println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }

    // This function is performed just before a segue is about to be performed, so it is great for passing data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // prepare to perform segue - setting up passing the data
        if (segue.identifier == "stopRecording") { // Important check for when multiple segue pass data to the same recieving view controller
            // get a handle on the second view controller in the app and assign to the variable playSoundsVC
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            // sender is the object that initiated the segue - in our case recordedAudio - this creates a variable data with the recordedAudio
            let data = sender as RecordedAudio
            // The data us then passed to the recievedAudio object in playSoundVC - i.e. the recieving View Controller
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true
        // Stop recording the user's voice
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil)
    }
}



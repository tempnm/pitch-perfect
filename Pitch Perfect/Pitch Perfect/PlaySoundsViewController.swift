//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Richard Hall on 03/04/2015.
//  Copyright (c) 2015 RH. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    // Outlet buttons for Play Sounds View Controller - enables their animation, such as hiding
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthvaderButton: UIButton!
    @IBOutlet weak var pressbuttonsLabel: UILabel!

    // This variable / object is the AVAudioPlayer
    var audioPlayer:AVAudioPlayer!
    // This variable recieves the audio data from the previous view controller
    var receivedAudio:RecordedAudio!

    // This varaible / object is the AVAudioEngine enabling sound effects - such as pitch alteration
    var audioEngine:AVAudioEngine!
    // This is the actual audioFile object.
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        // recieve the Audio from the Record Sounds View Controller - via recieveAudio object
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        // To change the rate it is necessary to modify enableRate
        audioPlayer.enableRate = true

        // Set up (initialise) the Audio Engine to enable acess to the methods, such as for Pitch effects.
        audioEngine = AVAudioEngine()
        // audioFile to transfer recievedAudio into formate required for playing with AudioEngine
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        // Play audio slowly here....
        slowButton.enabled = false
        // Helper function used stopping and resetting audio player and engine
        stopAndResetHelper()
        
        audioPlayer.rate = 0.5          // adjust the playback rate down
        audioPlayer.currentTime = 0.0   // restart from the beginning of track
        audioPlayer.play()
    }

    @IBAction func playFastAudio(sender: UIButton) {
        // Play audio quickly here...
        fastButton.enabled = false
        // Helper function used stopping and resetting audio player and engine
        stopAndResetHelper()
        
        audioPlayer.rate = 1.5          // adjust the playback rate up
        audioPlayer.currentTime = 0.0   // restart from the beginning of track
        audioPlayer.play()
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        // play high pitch audio - Chipmunk
        chipmunkButton.enabled = false
        playAudioWithVariablePitch(1000)  // passed parameter sets the pitch higher
    }

    @IBAction func playDarthvaderAudio(sender: UIButton) {
        // play low pitch audio - Darth Vader
        darthvaderButton.enabled = false
        playAudioWithVariablePitch(-1000)  // passed parameter sets the pitch lower
    }

    @IBAction func stopAudio(sender: UIButton) {
        // Stop any audio playing
        audioPlayer.stop()
        
        // Re-enable the other buttons
        slowButton.enabled = true
        fastButton.enabled = true
        chipmunkButton.enabled = true
        darthvaderButton.enabled = true
    }

    func stopAndResetHelper() {
        // Helper method for stopping the audio player and engine and resetting them - for if they were already running
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

    func playAudioWithVariablePitch(pitch: Float){
        // Play audio with variable pitch using AudioEngine class - for Chipmunk and Darth Vader Effects
        
        // Helper function used stopping and resetting audio player and engine
        stopAndResetHelper()

        // Create audioPlayerNode
        var audioPlayerNode = AVAudioPlayerNode()
        // Attach audioPlayerNode to the audioEngine
        audioEngine.attachNode(audioPlayerNode)

        
        // Create changePitchEffect
        var changePitchEffect = AVAudioUnitTimePitch()
        // Set the pitch according to the variable pitch passed into this function
        changePitchEffect.pitch = pitch
        // Attach attachNode to the audioEngine
        audioEngine.attachNode(changePitchEffect)

        // Connect the audioPlayerNode to the changePitchEffect
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        // Connect the changePitchEffect to the audioEngine output - in our case the speakers
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)

        // uses audioFile set up in View did load using the recieved Audio NSURL
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        // Start the audioEngine before use
        audioEngine.startAndReturnError(nil)

        // Play the Audio player
        audioPlayerNode.play()
    }
}



//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by سارا on 25/01/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import UIKit

import AVFoundation
class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate{
    
    var audioRecorder : AVAudioRecorder!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK : - view Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
       stopRecordingButton.isEnabled = false
    }
    
     // MARK : - view Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }
    
            // MARK : - record Audio
    @IBAction func recordAudio(_ sender: Any) {
        
       configureUI(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
    
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
           // MARK : - stop Recording
    @IBAction func stopRecording(_ sender: Any) {
        
       configureUI(false)
    
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
            // MARK : - audio RecorderDid Finish Recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    
         if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
            // MARK : - view Will Appear
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func configureUI(_ playState: Bool) {
        switch(playState) {
        case true:
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
            recordingLabel.text = "recording in progress"
        case false:
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text = "tap to record"
        }
    }
}

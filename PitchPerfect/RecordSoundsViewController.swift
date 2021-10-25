
//
//  ViewController.swift
//  PitchPerfect
//
//  Created by macmini on 21/07/21.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchButtonsStatus(isRecording: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // toggles status of the "record" and "stop recording" buttons based on each other; when one is enabled, the other is disabled
    func switchButtonsStatus(isRecording: Bool) {
        stopRecordingButton.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
        recordingLabel.text = isRecording ? "Recording in progress" : "Tap To Record"
    }
    
    // starts recording using AVAudioRecorder and storing the result on the file "recordedVoice.wav"
    @IBAction func recordAudio(_ sender: AnyObject) {
        switchButtonsStatus(isRecording: true)
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
    
    @IBAction func stopRecording(_ sender: Any) {
        switchButtonsStatus(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // is called by the AVAudioRecorder when the recording stops, and if it was successful, presents the next view
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundSVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundSVC.recordedAudioURL = recordedAudioURL
        }
    }
}


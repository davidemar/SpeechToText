//
//  ViewController.swift
//  SpeechToText
//
//  Created by David Mar on 4/24/18.
//  Copyright © 2018 davidMar. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!

    
    @IBOutlet weak var detectedText: UITextView!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "es-MX"))
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        self.recordAndRecognizeSpeech()
    }
    
    @IBAction func localFileButtonTapped(_ sender: Any) {
        self.recognizeFile()
    }
    
    func recordAndRecognizeSpeech() {
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }
        
        if !myRecognizer.isAvailable {
            print("not available right now")
            return
        }
        
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result {
                let text = result.bestTranscription.formattedString
                self.detectedText.text = text
            } else if let error = error {
                print(error)
            }
        })
        
    }
    
    func recognizeFile() {
        
        let audioURL = Bundle.main.url(forResource: "prueba", withExtension: "mp3")
        
        let recognitionRequest = SFSpeechURLRecognitionRequest(url: audioURL!)
        
        recognitionRequest.shouldReportPartialResults = true
        
        if (speechRecognizer?.isAvailable)! {
            
            speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                guard error == nil else { print("Error: \(error!)"); return }
                guard let result = result else { print("No result!"); return }
                
                self.detectedText.text = result.bestTranscription.formattedString

            }
        } else {
            print("Device doesn't support speech recognition")
        }
        
    }
    
}

extension ViewController: SFSpeechRecognizerDelegate {
    
    
    
}

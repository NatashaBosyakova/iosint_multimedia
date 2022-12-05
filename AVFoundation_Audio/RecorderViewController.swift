//
//  RecorderViewController.swift
//  AVFoundation_Audio
//
//  Created by Наталья Босякова on 04.12.2022.
//

import UIKit
import AVFoundation

class RecoderViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var player = AVAudioPlayer()
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var timerRecord: Timer! = nil
    var time: TimeInterval = 0 {
        didSet {
            labelTime.text = getTimeString()
        }
    }
    
    private lazy var labelPermition: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Permission: "
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var recoderView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing

        return stackView
    }()
    
    private lazy var buttonPlay: UIButton = {
        
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        config.baseForegroundColor = .gray
        config.baseBackgroundColor = .systemGray6
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(play), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    private lazy var buttonRecord: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "record.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        config.baseForegroundColor = .gray
        config.baseBackgroundColor = .systemGray6
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(startRecord), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    private lazy var labelTime: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = getTimeString()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        view.backgroundColor = .systemGray5
        
        view.addSubview(labelPermition)

        recoderView.addArrangedSubview(buttonPlay)
        recoderView.addArrangedSubview(buttonRecord)
        recoderView.addArrangedSubview(labelTime)
        view.addSubview(recoderView)
        
        NSLayoutConstraint.activate([
            labelPermition.bottomAnchor.constraint(equalTo: recoderView.topAnchor, constant: -8),
            labelPermition.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            recoderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            recoderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
    
    private func prepareToRecord() {
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() {allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.labelPermition.text = "Permission: allowed"
                    } else {
                        self.labelPermition.text = "Permission: forbidden"
                    }
                }
            }
            
        }
        catch {
            self.labelPermition.text = "Permission: error (\(error.localizedDescription))"
        }
    }
        
    @objc private func play() {
        
        if FileManager().fileExists(atPath: getDocumentsDirectory().appendingPathComponent("recording.m4a").path)  {
            
            if player.isPlaying {
                buttonPlay.configuration?.image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
                player.stop()
                player.currentTime = 0
            }
            else {
                prepareToPlay()
                buttonPlay.configuration?.image = UIImage(systemName: "stop.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
                player.play()
            }
        }
        else {
            let alert = UIAlertController(
                title: "File \"recording.m4a\" doesn't exist",
                message: "Create file by button \"Record\"",
                preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "OK",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in print("OK") }))
            alert.view.tintColor = .black
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func prepareToPlay() {
        do {
            
            let urlFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            
            player = try AVAudioPlayer(contentsOf: urlFilename)
            player.delegate = self
            player.prepareToPlay()
            
        }
        catch {
            print(error)
        }
    }
    
    @objc private func startRecord() {
        
        let urlFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        prepareToRecord()

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        if audioRecorder != nil {
            self.buttonRecord.configuration?.image = UIImage(systemName: "record.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            self.buttonRecord.imageView?.alpha = 1
            self.buttonRecord.configuration?.baseForegroundColor = .gray
            timerRecord.invalidate()
            audioRecorder.stop()
            audioRecorder = nil
        }
        else {
            do {
                
                audioRecorder = try AVAudioRecorder(url: urlFilename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                self.time = 0
                self.buttonRecord.configuration?.image = UIImage(systemName: "stop.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
                self.buttonRecord.configuration?.baseForegroundColor = .red
                UIButton.animate(withDuration: 0.6, delay: 0.0, options: UIView.AnimationOptions.repeat, animations: {
                        self.buttonRecord.imageView?.alpha = 0
                }, completion: nil)
                                
                timerRecord = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                    guard let self else { return }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.time = self.time + 1
                    })
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getTimeString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        let formattedString = formatter.string(from: time)!
        return formattedString
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        buttonPlay.configuration?.image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
    }
}

//
//  ViewController.swift
//  AVFoundation_Audio
//
//  Created by Niki Pavlove on 18.02.2021.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController, AVAudioPlayerDelegate {
    
    var player = AVAudioPlayer()
    
    var library: [[String: String]] = [
        ["fileName": "EvgeniyAlekseev",
         "fileType": "mp3",
         "trackName": "Евгений Алексеев – Солдатами не рождаются (Piano Tribute to Гражданская Оборона)"],
        
        ["fileName": "Powerwolf",
         "fileType": "mp3",
         "trackName": "Powerwolf – Demons Are a Girl's Best Friend"],

        ["fileName": "RostislavChebykin",
         "fileType": "mp3",
         "trackName": "Ростислав Чебыкин – Войны пафоса"],

        ["fileName": "SystemOfADown",
         "fileType": "mp3",
         "trackName": "System of a Down – Chop Suey!"],

        ["fileName": "Queen",
         "fileType": "mp3",
         "trackName": "Queen - The Show Must Go On"]
    ]
    
    var currentTrack = Int.random(in: 0...4)
    
    private lazy var playerView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing

        return stackView
    }()
    
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
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
    
    private lazy var buttonStop: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "stop.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        config.baseForegroundColor = .gray
        config.baseBackgroundColor = .systemGray6
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(stop), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    private lazy var buttonNext: UIButton = {
        
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        config.baseForegroundColor = .gray
        config.baseBackgroundColor = .systemGray6
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(nextTrack), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    private lazy var buttonPrevious: UIButton = {
        
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        config.baseForegroundColor = .gray
        config.baseBackgroundColor = .systemGray6
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(previousTrack), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    override func viewDidLoad() {

        super.viewDidLoad()
        
        view.backgroundColor = .systemGray5
        
        view.addSubview(labelName)
        playerView.addArrangedSubview(buttonPrevious)
        playerView.addArrangedSubview(buttonPlay)
        playerView.addArrangedSubview(buttonStop)
        playerView.addArrangedSubview(buttonNext)
        view.addSubview(playerView)
        
        NSLayoutConstraint.activate([
            labelName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            labelName.heightAnchor.constraint(equalToConstant: 80),
            labelName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            labelName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            
            playerView.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 16),
            playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        prepareToPlay()
        
    }
    
    private func prepareToPlay(isPlaying: Bool = false) {
        do {
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: library[currentTrack]["fileName"], ofType: library[currentTrack]["fileType"])!))
            player.delegate = self
            player.prepareToPlay()
            labelName.text = library[currentTrack]["trackName"]
            if isPlaying {
                player.play()
            }
        }
        catch {
            print(error)
        }
    }

    @objc private func play() {
        if player.isPlaying {
            buttonPlay.configuration?.image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            player.stop()
        }
        else {
            buttonPlay.configuration?.image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            player.play()
        }
    }
    
    @objc private func stop() {
        player.currentTime = 0
        if player.isPlaying {
            buttonPlay.configuration?.image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
            player.stop()
        }
        else {
            print("Already stopped!")
        }
    }

    @objc private func nextTrack() {
        currentTrack = currentTrack == library.count - 1 ? 0 : currentTrack + 1
        prepareToPlay(isPlaying: player.isPlaying)
    }

    @objc private func previousTrack() {
        currentTrack = currentTrack == 0 ? library.count - 1 : currentTrack - 1
        prepareToPlay(isPlaying: player.isPlaying)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        nextTrack()
        self.player.play()
    }
    
}

//
//  File.swift
//  AVFoundation_Audio
//
//  Created by Наталья Босякова on 04.12.2022.
//

import WebKit
import SwiftUI

class VideoPlayerViewController: UIViewController {
    
    var playList: [String] = [
        "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8",
        "https://www.youtube.com/watch?v=zwIKJocb5Ck",
        "https://www.youtube.com/watch?v=sPyAQQklc1s",
        "https://www.youtube.com/watch?v=gAzaeA-ifNE"]
    
    var currentVideo: Int? = nil
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .systemGray5
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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

    @IBAction func play(currentVideo: Int) {

        let controller = VideoView(url: playList[currentVideo])
        present(controller, animated: true)

    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        view.backgroundColor = .systemGray5
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
}

extension VideoPlayerViewController: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemGray5
        cell.textLabel?.text = self.playList[indexPath.row]
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 3
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return "play list:"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        play(currentVideo: indexPath.row)
    }
}

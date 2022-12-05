//
//  SceneDelegate.swift
//  AVFoundation_Audio
//
//  Created by Niki Pavlove on 18.02.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let audio = UINavigationController()
        audio.tabBarItem.title = "Audio player"
        audio.tabBarItem.image = UIImage(systemName: "music.note")
        audio.viewControllers.append(AudioPlayerViewController())
        
        let video = UINavigationController()
        video.tabBarItem.title = "Video player"
        video.tabBarItem.image = UIImage(systemName: "video.fill")
        video.viewControllers.append(VideoPlayerViewController())

        let recorder = UINavigationController()
        recorder.tabBarItem.title = "Recorder"
        recorder.tabBarItem.image = UIImage(systemName: "record.circle.fill")
        recorder.viewControllers.append(RecoderViewController())
                
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [audio, video, recorder]
        tabBarController.tabBar.layer.backgroundColor = UIColor.systemGray5.cgColor
        tabBarController.tabBar.tintColor = .purple

        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


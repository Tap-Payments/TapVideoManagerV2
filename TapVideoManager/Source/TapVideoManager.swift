//
//  TapVideoManager.swift
//  TapVideoManager
//
//  Created by Dennis Pashkov on 12/13/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

/// Video manager protocol
public protocol TapVideoManager: ClassProtocol {
    
    // MARK: Properties
    
    /// Defines if video is ready to play.
    var canPlayVideo: Bool { get }
    
    /// Video URL of video to play.
    var videoURL: URL? { get }
}

public extension TapVideoManager {
    
    /// Opens video player and plays video.
    public func playVideo() {
        
        guard self.canPlayVideo && !VideoPlayerViewController.isAlive else { return }
        
        let videoPlayerController = VideoPlayerViewController.instantiate()
        videoPlayerController.videoURL = self.videoURL
        
        videoPlayerController.show(animated: true)
    }
}

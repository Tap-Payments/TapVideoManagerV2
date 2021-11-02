//
//  VideoPlayerViewController.swift
//  TapVideoManager
//
//  Created by Dennis Pashkov on 12/13/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import AVFoundation
import TapGLKitV2
import TapViewControllerV2
import UIKit

/// Video Player View Controller.
public class VideoPlayerViewController: PopupViewController {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Defines whether there is at least one alive instance.
    public static var isAlive: Bool {
        
        return self.instancesCount > 0
    }
    
    /// URL to play the video.
    public var videoURL: URL? {
        
        didSet {
            
            self.assignURLToPlayer()
        }
    }
    
    // MARK: Methods
    
    public override class func instantiate() -> Self {
        
        guard let result = UIStoryboard.video.instantiateViewController(withIdentifier: self.tap_className) as? VideoPlayerViewController else {
            
            fatalError("Failed to load \(self.tap_className) from storyboard.")
        }
        
        self.instancesCount += 1
        
        return result.tap_asSelf()
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        self.addObservers()
        self.assignURLToPlayer()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        TapVideoManagerConnector.applicationInterface?.forcesPortraitOrientation = false
        
        self.performAutomaticClickOnOverlayViewAfter(delay: 2.0)
        
        self.activityIndicatorView?.startAnimating()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.play()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        
        TapVideoManagerConnector.applicationInterface?.forcesPortraitOrientation = true
        
        self.pause()
        
        super.viewWillDisappear(animated)
    }
    
    public override func viewWillLayoutSubviews() {
        
        self.view.tap_stickToSuperview()
        super.viewWillLayoutSubviews()
    }
    
    public override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.updatePlayerLayerFrame()
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        var observed = false
        
        guard let nonnullPlayer = self.player else { return }
        
        if keyPath == Constants.avPlayerRateKey && (object as? AVPlayer) == nonnullPlayer {
            
            observed = true
            
            if nonnullPlayer.tap_isPlaying {
                
                self.activityIndicatorView?.stopAnimating()
            }
        }
        
        if !observed {
            
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        
        self.player?.removeObserver(self, forKeyPath: Constants.avPlayerRateKey)
        self.player = nil
        
        self.playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
        
        self.removeObservers()
        
        type(of: self).instancesCount -= 1
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let avPlayerRateKey = "rate"
        
        fileprivate static let playVideoImage: UIImage = {
            
            guard let result = UIImage(named: "btn_play_video", in: .videoManagerResourcesBundle, compatibleWith: nil) else {
                
                fatalError("There is no image named btn_play_video in video manager resources bundle.")
            }
            
            return result
        }()
        
        fileprivate static let pauseVideoImage: UIImage = {
            
            guard let result = UIImage(named: "btn_pause_video", in: .videoManagerResourcesBundle, compatibleWith: nil) else {
                
                fatalError("There is no image named btn_pause_video in video manager resources bundle.")
            }
            
            return result
        }()
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private static var instancesCount = 0
    
    @IBOutlet private weak var playerContainerView: UIView? {
        
        didSet {
            
            self.addPlayerToTheView()
        }
    }
    
    @IBOutlet private weak var overlayView : UIView?
    @IBOutlet private weak var playButton : UIButton?
    
    @IBOutlet private weak var activityIndicatorView : TapActivityIndicatorView?
    
    private var player: AVPlayer? {
        
        didSet {
            
            self.addPlayerToTheView()
        }
    }
    
    private var playerLayer: AVPlayerLayer?
    
    // MARK: Methods
    
    private func assignURLToPlayer() {
        
        guard self.player == nil else { return }
        guard let url = self.videoURL else { return }
        
        let videoPlayer = AVPlayer(url: url)
        videoPlayer.addObserver(self, forKeyPath: Constants.avPlayerRateKey, options: [], context: nil)
        
        self.player = videoPlayer
    }
    
    private func addPlayerToTheView() {
        
        guard self.playerLayer == nil else { return }
        guard let nonnullPlayer = self.player, let nonnullContainer = self.playerContainerView else { return }
        
        let layer = AVPlayerLayer(player: nonnullPlayer)
        
        self.playerLayer = layer
        
        self.updatePlayerLayerFrame()
        
        nonnullContainer.layer.addSublayer(layer)
    }
    
    private func updatePlayerLayerFrame() {
        
        guard let nonnullLayer = self.playerLayer, let nonnullContainer = self.playerContainerView else { return }
        
        nonnullLayer.frame = nonnullContainer.bounds
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidReachEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStalled(_:)), name: .AVPlayerItemPlaybackStalled, object: nil)
    }
    
    private func removeObservers() {
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemPlaybackStalled, object: nil)
    }
    
    @objc private func playerDidReachEnd(_ notification: Notification) {
        
        self.close()
    }
    
    @objc private func playbackStalled(_ notification: Notification) {
        
        self.activityIndicatorView?.startAnimating()
    }
    
    private func play() {
        
        self.player?.play()
        self.playButton?.setImage(Constants.pauseVideoImage, for: .normal)
    }
    
    private func pause() {
        
        self.player?.pause()
        self.playButton?.setImage(Constants.playVideoImage, for: .normal)
    }
    
    @IBAction private func playButtonTouchUpInside(_ sender : UIButton?) {
        
        guard let nonnullPlayer = self.player else { return }
        
        if nonnullPlayer.tap_isPlaying {
            
            self.pause()
        }
        else {
            
            self.play()
        }
    }
    
    @IBAction private func overlayViewTapped(_ sender : AnyObject?) {
        
        DispatchQueue.main.async {
            
            self.overlayView?.isHidden = !self.overlayView!.isHidden
            
            self.cancelAllScheduledAutomaticClicksOnOverlayView()
            
            if !self.overlayView!.isHidden {
                
                self.performAutomaticClickOnOverlayViewAfter(delay: 5.0)
            }
        }
    }
    
    @IBAction private func closeButtonTouchUpInside(_ sender : UIButton?) {
        
        self.close()
    }
    
    private func performAutomaticClickOnOverlayViewAfter(delay : TimeInterval) {
        
        self.cancelAllScheduledAutomaticClicksOnOverlayView()
        self.perform(#selector(overlayViewTapped(_:)), with: nil, afterDelay: delay)
    }
    
    private func cancelAllScheduledAutomaticClicksOnOverlayView() {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(overlayViewTapped(_:)), object: nil)
    }
    
    private func close() {
        
        self.pause()
        
        TapVideoManagerConnector.applicationInterface?.forcePortraitOrientationAndRotate {
        
            self.hide(animated: true)
        }
    }
}


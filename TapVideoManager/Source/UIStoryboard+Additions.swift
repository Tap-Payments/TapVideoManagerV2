//
//  UIStoryboard+Additions.swift
//  TapVideoManager
//
//  Created by Dennis Pashkov on 12/14/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import class UIKit.UIStoryboard.UIStoryboard

/// Handy extension to UIStoryboard.
internal extension UIStoryboard {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Countries storyboard.
    internal static let video = UIStoryboard(name: "Video", bundle: .videoManagerResourcesBundle)
}

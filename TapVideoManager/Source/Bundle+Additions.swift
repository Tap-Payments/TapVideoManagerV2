//
//  Bundle+Additions.swift
//  TapVideoManager
//
//  Created by Dennis Pashkov on 12/14/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

internal extension Bundle {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Video Manager Resources bundle.
    internal static let videoManagerResourcesBundle: Bundle = {
        
        guard let result = Bundle(for: VideoPlayerViewController.self).tap_childBundle(named: TapVideoManagerConstants.resourcesBundleName) else {
            
            fatalError("There is no \(TapVideoManagerConstants.resourcesBundleName) bundle.")
        }
        
        return result
    }()
}

private struct TapVideoManagerConstants {
    
    fileprivate static let resourcesBundleName = "TapVideoManagerResources"
    
    @available(*, unavailable) init() {}
}

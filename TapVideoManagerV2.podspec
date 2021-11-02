Pod::Spec.new do |tapVideoManager|
    
    tapVideoManager.platform = :ios
    tapVideoManager.ios.deployment_target = '10.0'
    tapVideoManager.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
    tapVideoManager.name = 'TapVideoManagerV2'
    tapVideoManager.summary = 'Video Manager Interface + Video Player Controller'
    tapVideoManager.requires_arc = true
    tapVideoManager.version = '1.0.1'
    tapVideoManager.license = { :type => 'MIT', :file => 'LICENSE' }
    tapVideoManager.author = { 'Osama Rabie' => 'o.rabie@tap.company' }
    tapVideoManager.homepage = 'https://github.com/Tap-Payments/TapVideoManagerV2'
    tapVideoManager.source = { :git => 'https://github.com/Tap-Payments/TapVideoManagerV2.git', :tag => tapVideoManager.version.to_s }
    tapVideoManager.source_files = 'TapVideoManager/Source/*.swift'
    tapVideoManager.ios.resource_bundle = { 'TapVideoManagerResources' => 'TapVideoManager/Resources/*.{storyboard,xcassets}' }
    
    tapVideoManager.dependency 'TapAdditionsKitV2'
    tapVideoManager.dependency 'TapApplicationV2'
    tapVideoManager.dependency 'TapGLKitV2'
    tapVideoManager.dependency 'TapViewControllerV2'
    
end

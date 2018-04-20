source 'https://github.com/CocoaPods/Specs.git'

target 'Yamo' do
    platform :ios, '8.0'
    use_frameworks!
    inhibit_all_warnings!

    # Public Pods
    pod 'FBSDKCoreKit', '~> 4.16'
    pod 'FBSDKLoginKit', '~> 4.16'
    pod 'FBSDKShareKit', '~> 4.16'
    pod 'HockeySDK'
    pod 'AFNetworking', '~> 3.0'
    pod 'Mantle'
    pod 'MTLManagedObjectAdapter'
    pod 'Flurry-iOS-SDK'
    pod 'GoogleMaps'
    pod 'Firebase/Core'
    

    # Private Pods
    pod 'LOCManagers', :git => 'git@bitbucket.org:thisisglance/locmanagers.git', :tag => '0.9'
    pod 'LOCGenericLogin', :git => 'git@bitbucket.org:thisisglance/locgenericlogin.git', :tag => '1.1.1'
    pod 'LOCPasswordTextField', :git => 'git@bitbucket.org:thisisglance/locpasswordtextfield.git', :tag => '1.0.4'
    pod 'LOCSearchBar', :git => 'git@bitbucket.org:thisisglance/locsearchbar.git', :tag => '1.1'
    pod 'LOCCameraView', :git => 'git@bitbucket.org:thisisglance/loccameraview.git', :tag => '1.0.1'
    pod 'LOCPermissions-Swift/Location', :git => 'git@bitbucket.org:thisisglance/locpermissions-swift.git', :tag => '1.4.2'
    pod 'LOCPermissions-Swift/Notification', :git => 'git@bitbucket.org:thisisglance/locpermissions-swift.git', :tag => '1.4.2'
    pod 'LOCScrollingTabViewController', :git => 'git@bitbucket.org:thisisglance/locscrollingtabviewcontroller.git', :tag => '0.2.3' 
    pod 'LOCSubscription', :git => 'git@bitbucket.org:thisisglance/locsubscription.git', :tag => '0.0.7'
    pod 'LOCFloatingTextField', :git => 'git@bitbucket.org:thisisglance/locfloatingtextfield.git', :tag => '1.0.10'

    # Private Pods - LOCExtensions
    pod 'NSFileManager-LOCExtensions', :git => 'git@bitbucket.org:thisisglance/nsfilemanager-locextensions.git', :tag => '1.0'
    pod 'NSDate-LOCExtensions', :git => 'git@bitbucket.org:thisisglance/nsdate-locextensions.git', :tag => '1.0'
    pod 'NSString-LOCExtensions', :git => 'git@bitbucket.org:thisisglance/nsstring-locextensions.git', :tag => '1.0'
    pod 'NSArray-LOCExtensions', :git => 'git@bitbucket.org:thisisglance/nsarray-locextensions.git', :tag => '1.0'
    pod 'NSObject-LOCExtensions', :git => 'git@bitbucket.org:thisisglance/nsobject-locextensions.git', :tag => '1.0'
    pod 'MTLModel-LOCExtensions', :git => 'git@bitbucket.org:thisisglance/mtlmodel-locextensions.git', :tag => '1.1.5'
    pod 'UIView-LOCExtensions', :git => 'git@bitbucket.org:thisisglance/uiview-locextensions.git', :tag => '1.22'
    pod 'UIColor-LOCExtensions', :git => 'git@bitbucket.org:thisisglance/uicolor-locextensions.git', :tag => '1.1'
    pod 'UIImage-LOCExtensions', :git => 'git@bitbucket.org:thisisglance/uiimage-locextensions.git', :tag => '1.1'
    pod 'UIButton-LOCExtensions', :git => 'git@bitbucket.org:thisisglance/uibutton-locextensions.git', :tag => '1.0.2'
    pod 'UIAlertController-LOCExtensions', :git => 'git@bitbucket.org:thisisglance/uialertcontroller-locextensions.git', :tag => '1.0'
    pod 'UIImageView-LOCExtensions', :git => 'git@bitbucket.org:thisisglance/uiimageview-locextensions.git', :tag => '1.0'
    pod 'UIImagePickerController-LOCExtensions', :git => 'git@bitbucket.org:thisisglance/uiimagepickercontroller-locextensions.git', :tag => '1.1'

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '2.3'
            end
        end
    end

end

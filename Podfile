platform :ios, '13.0'
use_frameworks!

[ 'ArcX' ].each do |t|
  target t do
    #For UI
    pod 'SnapKit', '~> 5.6.0'
    pod 'Kingfisher', '~> 6.3.1'
   pod 'SVGAPlayer', '~> 2.5.7'
#    pod 'FSPagerView', '~> 0.8.3'

    #For Tools
    pod 'Moya', '~> 15.0.0'
    pod 'XCGLogger', '~> 7.0.1'
    pod 'Starscream', '~> 4.0.4'
    pod 'SwiftyJSON', '~> 5.0.1'
    pod 'KeychainAccess', '~> 4.2.2'

  end
end

post_install do |installer|
 installer.generated_projects.each do |project|
   project.targets.each do |target|
     target.build_configurations.each do |config|
       config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
       config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
     end
   end
 end
end


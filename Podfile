source 'https://github.com/CocoaPods/Specs.git'

project 'RCTFH.xcodeproj'
platform :ios, '8.0'
#use_frameworks!

target 'RCTFH' do
  #Available Modes: + :complete The target inherits all behaviour from the parent. + :none The target inherits none of the behaviour from the parent. + :search_paths The target inherits the search paths of the parent only.
  inherit! :complete
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  #use_frameworks!

  # Pods for FH
  pod 'FH', '~> 3.1.1'
#  pod 'React',
#      :path => "../react-native",
#      :subspecs => [
#        "Core",
#        "ART",
#        "RCTActionSheet",
#        "RCTAnimation",
#        "RCTCameraRoll",
#        "RCTGeolocation",
#        "RCTImage",
#        "RCTNetwork",
#        "RCTText",
#        "RCTVibration",
#        "RCTWebSocket",
#        "DevSupport",
#        "BatchedBridge"
#      ]
#    pod 'Yoga',
#      :path => "../react-native/ReactCommon/yoga"

end

#post_install do |installer_representation|
#  puts "\n\nexecuting post_install task... #{installer_representation}"
#  installer_representation.pods_project.targets.each do |target|
#      #puts "\tprocessing target #{target}"
#      target.build_configurations.each do |config|
#            #printf("\n xcode project config: %s.\n", config)
#            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
#      end
#  end
#end

#
# Be sure to run `pod lib lint LCFramework.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LCFramework'
  s.version          = '1.0.0'
  s.summary          = 'A short description of LCFramework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        test
                       DESC

  s.homepage         = 'https://github.com/LIErCai/LCFramework'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LIErCai' => '1179542975@qq.com' }
  s.source           = { :git => 'https://github.com/LIErCai/LCFramework.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LCFramework/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LCFramework' => ['LCFramework/Assets/*.png']
  # }

  s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'TXLiteAVSDK_Player'
  s.dependency 'SocketRocket'

end

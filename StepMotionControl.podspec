#
# Be sure to run `pod lib lint StepMotionControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'StepMotionControl'
  s.version          = '1.1.3'
  s.summary          = 'StepMotionControl私有库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        StepMotionControl私有库用于实现监控步数以及运动轨迹。
                       DESC

  s.homepage         = 'https://github.com/Devil-Lee/StepMotionControl'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Devil-Lee' => '1078980842@qq.com' }
  s.source           = { :git => 'https://github.com/Devil-Lee/StepMotionControl.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'

  s.source_files = 'StepMotionControl/Classes/**/*'
  
  # s.resource_bundles = {
  #   'StepMotionControl' => ['StepMotionControl/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

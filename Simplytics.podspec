#
# Be sure to run `pod lib lint Simplytics.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Simplytics'
  s.version          = '0.1.0'
  s.summary          = 'Mobile app analytics for Salesforce, made simple.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Add mobile analytics to Salesforce native apps and track funnels, events, actions and app information. 
                       DESC

  s.homepage         = 'https://github.com/quintonwall/Simplytics'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'quintonwall' => 'hell@quinton.me' }
  s.source           = { :git => 'https://github.com/quintonwall/Simplytics.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/quintonwall'

  s.ios.deployment_target = '11.0'

  s.source_files = 'Simplytics/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Simplytics' => ['Simplytics/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'RealmSwift', '~> 3.0.2'
  s.dependency 'SwiftlySalesforce'

end

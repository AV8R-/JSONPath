#
# Be sure to run `pod lib lint JSONPath.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JSONPath'
  s.version          = '0.1.0'
  s.summary          = 'The most simple JSON parsing for Swift.'

  s.description      = <<-DESC
JSONPath is JSON parsing libriry that relies on cutting edge technologies of Swift. It uses dynamicMemberLookup and Codable.
                       DESC

  s.homepage         = 'https://github.com/AV8R-/JSONPath'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bogdan Manshilin' => 'manshilin@yandex-team.ru' }
  s.source           = { :git => 'https://github.com/AV8R-/JSONPath.git', :tag => s.version.to_s }

  s.ios.deployment_target = ''
  s.osx.deployment_target = ''
  s.watchos.deployment_target = ''
  s.tvos.deployment_target = ''
  s.swift_version = '4.2'

  s.source_files = 'JSONPath/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JSONPath' => ['JSONPath/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

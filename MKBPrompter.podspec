#
# Be sure to run `pod lib lint MKBPrompter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MKBPrompter"
  s.version          = "0.1.0"
  s.summary          = "Prompts the user to rate, review and view your other apps at specified intervals"

  s.homepage         = "https://github.com/Megatron1000/MKBPrompter"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Mark Bridges" => "mark@bridgetech.io" }
  s.source           = { :git => "https://github.com/Megatron1000/MKBPrompter.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/markbridgesapps'

  s.platforms = { :ios => "8.0" }
# s.source_files = 'MKBPrompter/MKBPrompter.{h,m}'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MKBPrompter' => ['Pod/Assets/*.lproj']
  }
  s.social_media_url = "https://twitter.com/markbridgesapps"

  # s.public_header_files = 'Pod/Classes/**/*.h'
end

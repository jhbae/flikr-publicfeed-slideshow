# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

def commonPods
    pod 'Alamofire', '~> 3.5.0'
    pod 'EasyMapping', '~> 0.18'
    #pod 'Alamofire-YamlSwift', '~> 1.0'
    pod 'AlamofireRSSParser', :git => 'https://github.com/AdeptusAstartes/AlamofireRSSParser.git', :tag => '1.0.7'
    pod 'AlamofireImage', '~> 2.0'
    pod 'Bolts-Swift', '~> 1.2.0'
end

target 'FlikrSlideShow' do
    commonPods
end

target 'FlikrSlideShowTests' do
    commonPods
end

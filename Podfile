# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

pod 'Result'
pod 'RxSwift'
pod 'RxCocoa'
pod 'Moya'
pod 'RealmSwift'

target 'ClientStack' do
  platform :ios, '11.3'
end

target 'ClientStackTests' do
  platform :ios, '11.3'
  inherit! :search_paths

  pod 'RxBlocking'
  pod 'RxTest'
end

target 'ClientStack_Mac' do
  platform :osx, '10.13'
end

target 'ClientStack_MacTests' do
  platform :osx, '10.13'
  inherit! :search_paths

  pod 'RxBlocking'
  pod 'RxTest'
end

target 'ClientStackDemo' do
  platform :osx, '10.13'
end

target 'ClientStackDemoTests' do
  platform :osx, '10.13'
  inherit! :search_paths

  pod 'RxBlocking'
  pod 'RxTest'
end

target 'KnzkAlt' do
  platform :ios, '11.3'

  pod 'HydraAsync'
  pod 'KeychainAccess'
  pod 'Deque', '~> 3.1'
  pod 'Fuzi', '~> 2.0.0'
  pod 'MastodonKit', :git => 'https://github.com/wtm4080/MastodonKit.git', :branch => 'develop-knzk'
  pod 'Kingfisher', '~> 4.0'
end

target 'KnzkAltTests' do
  platform :ios, '11.3'
  inherit! :search_paths

  pod 'RxBlocking'
  pod 'RxTest'
end

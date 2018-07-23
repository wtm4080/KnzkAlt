# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

pod 'Result'
pod 'RxSwift'
pod 'RxCocoa'
pod 'Moya/RxSwift'
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

target 'KnzkAlt' do
  platform :ios, '11.3'

  pod 'HydraAsync'
  pod 'KeychainAccess'
  pod 'Deque'
  pod 'Fuzi'
  pod 'MastodonKit', :git => 'https://github.com/wtm4080/MastodonKit.git', :branch => 'develop-knzk'
  pod 'Kingfisher'
end

target 'KnzkAltTests' do
  platform :ios, '11.3'
  inherit! :search_paths

  pod 'RxBlocking'
  pod 'RxTest'
end

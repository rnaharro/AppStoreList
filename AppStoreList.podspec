Pod::Spec.new do |s|
  s.name     = 'AppStoreList'
  s.version  = '2.0.1'
  s.platform = :ios, '16.0'
  s.license  = 'MIT'
  s.summary  = 'AppStoreList is a SwiftUI way of displaying apps from the App Store.'
  s.homepage = 'https://github.com/rnaharro/AppStoreList'
  s.author   = { 'Ricardo N.' => '@AppDelegate' }
  s.source   = { :git => 'https://github.com/rnaharro/AppStoreList.git', :tag => s.version.to_s }
  s.description = 'AppStoreList is a simple SwiftUI-based way of displaying apps from the App Store. Uses SKStoreProductViewController for a native experience.'
  s.swift_version = '5.10'
  s.source_files = [
    'AppStoreList/AppObject.swift',
    'AppStoreList/AppStoreList.swift',
    'AppStoreList/AppStoreViewModel.swift'
  ]
  s.exclude_files = ['AppStoreList/AppStoreListDemoApp.swift']
  s.frameworks = 'StoreKit'
  s.resources = 'AppStoreList/Resources/**/*'
  s.pod_target_xcconfig = {
    'SWIFT_OPTIMIZATION_LEVEL[config=Debug]' => '-Onone'
  }
end

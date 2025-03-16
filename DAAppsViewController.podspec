Pod::Spec.new do |s|
  s.name     = 'DAAppsViewController'
  s.version  = '2.0.0'
  s.platform = :ios, '16.0'
  s.license  = 'MIT'
  s.summary  = 'DAAppsViewController is a SwiftUI way of displaying apps from the App Store.'
  s.homepage = 'https://github.com/rnaharro/DAAppsViewController'
  s.author   = { 'Ricardo N.' => '@AppDelegate' }
  s.source   = { :git => 'https://github.com/rnaharro/DAAppsViewController.git', :tag => s.version.to_s }
  s.description = 'DAAppsViewController is a simple SwiftUI-based way of displaying apps from the App Store. Uses SKStoreProductViewController for a native experience.'
  s.swift_version = '5.10'
  s.source_files = [
    'DAAppsViewController/AppObject.swift',
    'DAAppsViewController/AppStoreList.swift',
    'DAAppsViewController/AppStoreViewModel.swift'
  ]
  s.exclude_files = ['DAAppsViewController/DAAppsViewControllerApp.swift']
  s.frameworks = 'StoreKit'
  s.resources = 'DAAppsViewController/Resources/**/*'
  s.pod_target_xcconfig = {
    'SWIFT_OPTIMIZATION_LEVEL[config=Debug]' => '-Onone'
  }
end

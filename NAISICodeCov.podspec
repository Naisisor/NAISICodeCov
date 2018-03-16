#
#  Be sure to run `pod spec lint NAISICodeCov.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "NAISICodeCov"
  s.version      = "1.0.0"
  s.summary      = "iOS code coverage generate `*.gcda` file and upload server"

  s.homepage     = "https://github.com/NAISI-ZC/NAISICodeCov"
  s.license      = 'MIT'
  s.author       = { "NAISI" => "naisi.futurn@gmail.com" }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/NAISI-ZC/NAISICodeCov.git", :tag => s.version}
  s.source_files  = 'NAISICodeCov/**/*.{h,m}'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'SSZipArchive'
  s.dependency 'SVProgressHUD'
end

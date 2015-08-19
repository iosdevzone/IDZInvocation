Pod::Spec.new do |s|
  s.name         = "IDZInvocation"
  s.version      = "0.1.0"
  s.summary      = "A category on NSInvocation to make argument value extraction less painful."

  s.homepage     = "https://github.com/iosdevzone/IDZInvocation"

  s.license      = "MIT"

  s.author             = { "iOS Developer Zone" => "idz@iosdeveloperzone.com" }
  s.social_media_url   = "http://twitter.com/iOSDevZone"

  s.ios.deployment_target = "5.0"
  s.osx.deployment_target = "10.7"

  s.source       = { :git => "https://github.com/iosdevzone/IDZInvocation.git", :tag => s.version.to_s }
  s.source_files  = "IDZInvocation"
  s.public_header_files = "IDZInvocation/*.h"
end

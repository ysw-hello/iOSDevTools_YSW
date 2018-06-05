Pod::Spec.new do |s|  
  s.name         = "iOSDevTool_YSW"
  s.version      = "0.0.1"
  s.summary      = "iOSDevTool_YSW是一个快速开发工具包"
  s.homepage     = "https://github.com/ysw-hello/iOSDevTool_YSW"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "ysw-hello" => "shiwei_work@aliyun.com" }
  s.social_media_url   = "https://www.jianshu.com/u/2745b6c5b019"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/ysw-hello/iOSDevTools_YSW.git", :tag => "{s.version}" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true

end

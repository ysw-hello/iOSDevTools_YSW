Pod::Spec.new do |s|
  s.name         = "iOSDevTools_YSW"
  s.version      = "0.0.1"
  s.summary      = "iOS Tools library"
  s.homepage     = "https://github.com/ysw-hello/iOSDevTools_YSW" # 你的主页
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "yanshiwei" => "shiwei_work@aliyun.com" }
  s.social_media_url   = "https://www.jianshu.com/u/2745b6c5b019"

  s.platform = :ios, "7.0"
  s.source       = { :git => "https://github.com/ysw-hello/iOSDevTools_YSW.git", :tag => "#{s.version}" }

  s.source_files  = "iOSDevTools_YSW/**/*.{h,m}"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true

end

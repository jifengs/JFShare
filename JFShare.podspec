#
#  Be sure to run `pod spec lint JFShare.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "JFShare"
s.version      = "0.0.1"
s.summary      = "share of JFShare."

s.description  = <<-DESC
JFShare of JiFeng
DESC

s.homepage     = "https://github.com/jifengs/JFShare.git"

s.license      = "MIT"

s.author             = { "jifeng" => "jf_feng@126.com" }
# Or just: s.author    = "jifeng"
# s.authors            = { "jifeng" => "jf_feng@126.com" }
# s.social_media_url   = "http://twitter.com/jifeng"

s.platform     = :ios, "8.0"

s.source       = { :git => "https://github.com/jifengs/JFShare.git", :tag => "#{s.version}" }
s.source_files  = "Share/*.{h,m}"
s.resources = "Share/share_icons/*.png"

# s.framework  = "SomeFramework"
# s.frameworks = "SomeFramework", "AnotherFramework"

# s.library   = "iconv"
# s.libraries = "iconv", "xml2"

# s.requires_arc = true

# s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
# s.dependency "JSONKit", "~> 1.4"

s.dependency "UMengUShare/Social/Sina"
s.dependency "UMengUShare/Social/WeChat"
s.dependency "UMengUShare/Social/QQ"
s.dependency "UMengUShare/Social/SMS"

end


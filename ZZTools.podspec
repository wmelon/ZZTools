
Pod::Spec.new do |s|

s.name				= "ZZTools"
s.version			= "0.0.1"
s.summary			= "first version"
s.description			= "first version for public"
s.author			= { "ZZ" => "1156858877@qq.com" }
s.platform			= :ios, "7.0"
s.license			= { :type => 'MIT', :file => 'LICENSE' }
s.homepage			= "https://github.com/iOS-ZZ/ZZTools.git"
s.source			= { :git => "https://github.com/iOS-ZZ/ZZTools.git", :tag => "#{s.version}" }
s.requires_arc			= true
s.frameworks			= 'UIKit'

s.source_files			= "ZZToolsDemo/ZZTools/ZZTools.h"
s.public_header_files		= "ZZToolsDemo/ZZTools/ZZTools.h"

# ―――――――――――――――――――――――――――――――  Subspec ――――――――――――――――――――――――――――――――――――#

  s.subspec 'ZZLayout' do |ss|
    ss.source_files 		= 'ZZToolsDemo/ZZTools/ZZLayout/ZZLayout.{h,m}'
    ss.public_header_files 	= 'ZZToolsDemo/ZZTools/ZZLayout/ZZLayout.h'
  end

end

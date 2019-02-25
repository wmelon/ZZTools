
Pod::Spec.new do |s|

s.name				= "ZZTools"
s.version			= "1.0.6"
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

# ―――――――――――――――――――――――――――――――  Subspecs ――――――――――――――――――――――――――――――――――――#

  s.subspec 'ZZLayout' do |ss|
    ss.source_files 		= 'ZZToolsDemo/ZZTools/ZZLayout/ZZLayout.{h,m}'
    ss.public_header_files 	= 'ZZToolsDemo/ZZTools/ZZLayout/ZZLayout.h'
  end

  s.subspec 'ZZStarView' do |ss|
    ss.source_files 		= 'ZZToolsDemo/ZZTools/ZZStarView/ZZStarView.{h,m}'
    ss.public_header_files 	= 'ZZToolsDemo/ZZTools/ZZStarView/ZZStarView'
  end

  s.subspec 'ZZRouter' do |ss|
    ss.source_files 		= 'ZZToolsDemo/ZZTools/ZZRouter/ZZRouter.{h,m}'
    ss.public_header_files 	= 'ZZToolsDemo/ZZTools/ZZRouter/ZZRouter'
  end

end

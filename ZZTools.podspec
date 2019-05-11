
Pod::Spec.new do |s|

s.name				= "ZZTools"
s.version			= "1.1.0"
s.summary			= "一些通用工具, 包括:瀑布流, 星星评价, 页面路由等, 详细见: https://github.com/iOS-ZZ/ZZTools"
s.description			= "1.瀑布流：自定义collectionView的布局，提供垂直＆水平＆浮动;水平＆多状态混合瀑布流效果（可实现淘宝SKU选择的浮动效果）, 支持设置不同分区不同背景颜色。"
s.description			= "2.星星评价：可自定义星星数量，分级，最低分，支持拖曳手势，支持半颗星（同样支持小数，最低0.01）。"
s.description			= "3.页面路由：模块解耦，组件化必备，用法简单，支持正向传值以及反向传值，无需继承，侵入性低。"
s.author			= { "ZZ" => "1156858877@qq.com" }
s.platform			= :ios, "8.0"
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
    ss.public_header_files 	= 'ZZToolsDemo/ZZTools/ZZStarView/ZZStarView.h'
  end

  s.subspec 'ZZRouter' do |ss|
    ss.source_files 		= 'ZZToolsDemo/ZZTools/ZZRouter/ZZRouter.{h,m}'
    ss.public_header_files 	= 'ZZToolsDemo/ZZTools/ZZRouter/ZZRouter.h'
  end

end

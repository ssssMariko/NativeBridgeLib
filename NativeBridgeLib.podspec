Pod::Spec.new do |s|
  # 框架的名称
  s.name             = 'NativeBridgeLib'
  # 框架的版本号
  s.version          = '0.1.2'
  # 框架的简单介绍
  s.summary          = 'web/h5 bridge model'
  # 框架的详细描述(详细介绍，要比简介长)
  s.description      = <<-DESC
web/h5 桥接到 native, native提供的本地化功能.
                       DESC
  # 框架的主页
  s.homepage         = 'https://github.com/ssssMariko/NativeBridgeLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  # 证书类型  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  # 作者  
  s.author           = { 'ssssMariko' => '18502702013@163.com' }
  s.source           = { :git => 'https://github.com/ssssMariko/NativeBridgeLib.git', :tag => s.version.to_s }
  # 社交网址
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  # 本地框架源文件的位置（包含所有文件）
  s.source_files = 'NativeBridgeLib/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NativeBridgeLib' => ['NativeBridgeLib/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.frameworks = 'Foundation','UIKit'
  s.dependency 'AFNetworking', '~> 3.2.0'
  s.dependency 'MBProgressHUD', '~> 1.1.0'
end

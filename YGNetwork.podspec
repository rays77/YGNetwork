Pod::Spec.new do |s|
  s.name             = 'YGNetwork'
  s.version          = '0.1.01'
  s.summary          = 'YGNetwork 是基于 AFNetworking 封装的网络请求库，便于项目中的使用'
  s.homepage         = 'https://github.com/rays77/YGNetwork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bh' => 'YG@mail.com' }
  s.source           = { :git => 'https://github.com/rays77/YGNetwork.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'YGNetwork/Classes/**/*'
  s.dependency 'AFNetworking', '4.0.1'
end

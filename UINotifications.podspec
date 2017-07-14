Pod::Spec.new do |s|
  s.name             = 'UINotifications'
  s.version          = '1.0.0'
  s.summary          = 'Present custom in-app notifications easily in Swift.'
  s.description      = 'Present custom in-app notifications easily in Swift with simple and highly customizable APIs.'

  s.homepage         = 'https://github.com/Antoine van der Lee/UINotifications'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Antoine van der Lee' => 'antoine@wetransfer.com' }
  s.source           = { :git => 'https://github.com/Antoine van der Lee/UINotifications.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/twannl'

  s.ios.deployment_target = '9.0'
  s.source_files = 'Source/**/*'
end

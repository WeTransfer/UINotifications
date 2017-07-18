Pod::Spec.new do |spec|
  spec.name             = 'UINotifications'
  spec.version          = '1.0.0'
  spec.summary          = 'Present custom in-app notifications easily in Swift.'
  spec.description      = 'Present custom in-app notifications easily in Swift with simple and highly customizable APIs.'

  spec.homepage         = 'https://github.com/WeTransfer/UINotifications'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.authors           = {
    'Antoine van der Lee' => 'antoine@wetransfer.com',
    'Samuel Beek' => 'ik@samuelbeek.com'
  }
  spec.source           = { :git => 'https://github.com/WeTransfer/UINotifications.git', :tag => spec.version.to_s }
  spec.social_media_url = 'https://twitter.com/WeTransfer'

  spec.ios.deployment_target = '9.0'
  spec.source_files = 'Sources/**/*'
end

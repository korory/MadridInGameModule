Pod::Spec.new do |s|
  s.name         = 'MadridInGameModule'
  s.version      = '1.0.2'
  s.summary      = 'Un módulo para integrar MadridInGame con funcionalidades avanzadas.'
  s.description  = <<-DESC
    MadridInGameModule es un módulo diseñado para facilitar la integración de experiencias interactivas de juego en aplicaciones iOS.
  DESC
  s.homepage     = 'https://github.com/korory/MadridInGameModule'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Diverger Thinking' => 'arnau.rivas@diverger.ai' }
  s.source       = { :git => 'https://github.com/korory/MadridInGameModule.git', :tag => s.version.to_s }

  s.ios.deployment_target = '16.0'
  s.source_files = 'MadridInGameModule/Classes/**/*.{swift}'
  
  s.resource_bundles = {
    'MadridInGameModule' => ['MadridInGameModule/Classes/**/*.{ttf,otf}']
  }
  
  s.swift_versions = ['5.0']

  s.dependency 'FontBlaster', '~> 5.3.0'

end


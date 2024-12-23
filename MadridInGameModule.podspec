Pod::Spec.new do |s|
  s.name         = 'MadridInGameModule'
  s.version      = '1.0.1'
  s.summary      = 'Un módulo para integrar MadridInGame con funcionalidades avanzadas.'
  s.description  = <<-DESC
    MadridInGameModule es un módulo diseñado para facilitar la integración de experiencias interactivas de juego en aplicaciones iOS.
  DESC
  s.homepage     = 'https://github.com/hamzadiverger/MadridInGameModule'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Tu Nombre' => 'hamza.elhamdaoui@diverger.ai' }
  s.source       = { :git => 'https://github.com/hamzadiverger/MadridInGameModule', :tag => s.version.to_s }

  s.ios.deployment_target = '17.0'
  s.source_files = 'MadridInGameModule/Classes/**/*.{swift}'
  s.resources    = 'MadridInGameModule/Resources/**/*'

end


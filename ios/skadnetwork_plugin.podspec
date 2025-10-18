Pod::Spec.new do |s|
  s.name             = 'skadnetwork_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin to set SKAdNetwork conversion values.'
  s.description      = 'Lightweight SKAdNetwork wrapper for conversion values (fine and coarse).'
  s.homepage         = 'https://github.com/vinothkumar-258/skAdNetwork'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Vinoth Kumar' => 'mail.vinothkumarr@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency       'Flutter'
  s.platform         = :ios, '14.0'
end

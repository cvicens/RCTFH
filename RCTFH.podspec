
Pod::Spec.new do |s|
  s.name         = "RCTFH"
  s.authors       = { "Carlos Vicens" => "cvicensa@redhat.com", "Rafael T. C. Soares" => "rsoares@redhat.com" }

  s.version      = "0.1.1"
  s.summary      = "React Native iOS bridge/wrapper..."
  s.license      = "MIT"

  s.homepage     = "https://github.com/rafaeltuelho/RCTFH"
  s.source       = { git: "https://github.com/rafaeltuelho/RCTFH.git", :tag => "#{s.version}" }

  s.requires_arc = true
  #s.source_files  = "*"
  s.source_files = './**/*.{m,h,mm,hpp,cpp,c}'
  s.platform     = :ios, "8.0"
  s.frameworks   = 'SystemConfiguration', 'CFNetwork', 'MobileCoreServices'
  s.libraries    = 'xml2','c++','z'
  #s.ios.frameworks = 'SystemConfiguration','CFNetwork', 'MobileCoreServices'
  #s.ios.library = 'xml2','c++','z'
  s.dependency "FH", "~> 3.1.1"
  #s.dependency "React"

end

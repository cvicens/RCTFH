
Pod::Spec.new do |s|
  s.name         = "RCTFH"
  s.author       = { "Carlos Vicens" => "cvicens@redhat.com" }

  s.version      = "0.1.0"
  s.summary      = "Native..."
  s.license      = "MIT"

  s.homepage     = "https://github.com/johndoe/nothing"
  s.source       = { git: "https://github.com/johndoe/nothing/rctfh.git", :tag => "#{s.version}" }

  s.requires_arc = true
  #s.source_files  = "*"
  s.source_files = './**/*.{m,h,mm,hpp,cpp,c}'
  s.platform     = :ios, "7.0"

  s.dependency "FH", "~> 3.1.1"
  s.dependency "React"

end

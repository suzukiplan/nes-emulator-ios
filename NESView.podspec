Pod::Spec.new do |s|
  s.name = "NESView"
  s.version = "0.1.0"
  s.summary = "NES emulator for iOS"
  s.homepage = "https://github.com/suzukiplan/nes-emulator-ios"
  s.author = 'SUZUKI PLAN'
  s.license = { :type => 'GPL-3.0', :file => 'LICENSE.txt' }
  s.platform = :ios, "10.0"
  s.source = { :git => "https://github.com/suzukiplan/nes-emulator-ios.git", :tag => "#{s.version}" }
  s.source_files = "NESView/**/*.{h,m,hpp,c,cpp}"
  s.frameworks = "OpenAL"
  s.preserve_path = "NESView.modulemap"
  s.module_map = "NESView.modulemap"
end

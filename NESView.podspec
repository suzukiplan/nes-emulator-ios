Pod::Spec.new do |s|
  s.name = "NESView"
  s.version = "1.0.0"
  s.summary = "NES emulator for iOS"
  s.homepage = "https://github.com/suzukiplan/nes-emulator-ios"
  s.author = 'SUZUKI PLAN'
  s.license = { :type => 'GPL-3.0', :file => 'LICENSE' }
  s.platform = :ios, "8.0"
  s.source = { :git => "https://github.com/suzukiplan/nes-emulator-ios.git", :tag => "#{s.version}" }
  s.source_files = "NESView/**/*.{h,m}"
  s.frameworks = "OpenAL"
  s.preserve_path = "NESView.modulemap"
  s.module_map = "NESView.modulemap"
end

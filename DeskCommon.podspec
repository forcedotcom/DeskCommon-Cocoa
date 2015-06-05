Pod::Spec.new do |s|
  s.name         = "DeskCommon"
  s.version      = "1.0.3"
  s.summary      = "Common code shared by Desk Cocoa projects"
  s.homepage     = "https://github.com/forcedotcom/DeskCommon-Cocoa"
  s.author       = { "Salesforce, Inc." => "mobile@desk.com" }
  s.source       = { :git => "https://github.com/forcedotcom/DeskCommon-Cocoa.git", :tag => "1.0.3" }
  s.platform     = :ios, '6.0'
  s.source_files = 'DeskCommon/DeskCommon/*.{h,m}', 'DeskCommon/DeskCommon/**/*.{h,m}'
  s.requires_arc = true
end

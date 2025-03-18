Pod::Spec.new do |s|
  s.name = 'FlexLayout'
  s.version = '0.0.1'
  s.summary = 'FlexLayout'
  s.license = 'MIT'
  s.author = 'Igor Postoev'
  s.platform = :ios, '15.0'
  s.requires_arc = true
  s.swift_version = '5.0'

  s.dependency 'SnapKit'

  s.subspec 'Source' do |ss|
    
    ss.source_files = 'Source/**/*.{h,m,swift}'
    ss.resources = '**/*.{storyboard,png,pdf,xib,bundle,xcassets}'
  end
end

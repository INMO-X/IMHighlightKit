#
# Binary pod for the static XCFramework produced by Scripts/build_xcframeworks.sh.
# IMBaseKit and third-party pods stay dependencies of the host. They are not vendored.
#
Pod::Spec.new do |s|
  s.name             = 'IMHighlightKit'
  s.version          = '0.1.2'
  s.summary          = 'INMO X Highlight (comic / collage task) SDK (static XCFramework)'
  s.description      = <<-DESC
  INMO X「精彩时刻」能力 SDK 静态二进制：漫画 / INS 拼接任务的创建上传、列表、详情、轮询、
  结果图落地与按用户隔离的本地缓存。IMBaseKit / Moya / ObjectMapper 由宿主工程链接同一份，
  不打进本 XCFramework。
                       DESC

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jiangqi' => 'jiangqi@inmolens.com' }
  s.homepage         = 'https://github.com/INMO-X/IMHighlightKit'
  s.source           = { :git => 'https://github.com/INMO-X/IMHighlightKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.swift_version    = '5.0'
  s.static_framework = true

  s.vendored_frameworks = 'XCFrameworks/IMHighlightKit.xcframework'

  s.frameworks = 'Foundation', 'CoreGraphics', 'ImageIO', 'UniformTypeIdentifiers'

  # 静态链接时随 App 拷贝的隐私清单。
  s.resource_bundles = {
    'IMHighlightKit' => ['IMHighlightKit/Resources/PrivacyInfo.xcprivacy']
  }

  s.dependency 'IMBaseKit', '0.1.2'
  s.dependency 'Moya', '15.0.0'
  s.dependency 'ObjectMapper', '4.4.2'
end

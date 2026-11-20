# IMHighlightKit

INMO「精彩时刻」能力 SDK 的 **静态 XCFramework**：漫画 / INS 拼接任务的创建上传、列表分页、详情、轮询、结果图落地与本地缓存。无 UI，按用户隔离。

IMBaseKit、Moya、ObjectMapper **不打进包**，由宿主链接同一份。网络请求复用 IMBaseKit 的 `IMCommonProvider`，自动带登录 token。

---

## 环境要求

- iOS 15.0+
- Swift 5
- Xcode 15+
- CocoaPods，并开启 `use_frameworks!`

## 安装

```ruby
platform :ios, '15.0'
use_frameworks! :linkage => :static

target 'YourApp' do
  pod 'IMBaseKit',      :git => 'https://github.com/INMO-X/IMBaseKit.git',      :tag => '0.1.2'
  pod 'IMHighlightKit', :git => 'https://github.com/INMO-X/IMHighlightKit.git', :tag => '0.1.2'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 15.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end
```

依赖版本与打这个包时一致：IMBaseKit 0.1.2、Moya 15.0.0、ObjectMapper 4.4.2。

调用前先用 `IMUtils.set(uid:token:)` 写入登录态，再 `IMHighlightKit.shared.configure(userID:)`。

## 隐私

创建任务时会把用户选择的图片上传到 INMO 服务端生成结果图。详见 [docs/PRIVACY.md](docs/PRIVACY.md)。

## 示例

[Example/](Example/) 用 tag `0.1.2` 绑定用户、读取本地任务和 INS 拼接开关，并计算轮询间隔。不登录也能运行。

```bash
cd Example
pod install
open IMHighlightKit.xcworkspace
```

## 文档

| 文档 | 说明 |
|------|------|
| [docs/USAGE.md](docs/USAGE.md) | 场景用法 |
| [docs/PRIVACY.md](docs/PRIVACY.md) | 隐私清单与宿主配置 |

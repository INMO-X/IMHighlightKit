# Privacy（IMHighlightKit）

框架自带的隐私清单，以及宿主 App 仍需自己配置的部分。

## 隐私清单（`PrivacyInfo.xcprivacy`）

源码路径：`IMHighlightKit/Resources/PrivacyInfo.xcprivacy`。

| Key | 取值 |
|-----|------|
| `NSPrivacyTracking` | `false`。框架不做跨 App / 网站追踪。 |
| `NSPrivacyTrackingDomains` | 空。 |
| `NSPrivacyCollectedDataTypes` | `NSPrivacyCollectedDataTypePhotosorVideos`：创建漫画 / INS 拼接任务时，把用户选择的图片上传到 INMO 服务端生成结果图；关联用户（请求带登录 token）、不用于追踪，目的是 App 功能。 |
| `NSPrivacyAccessedAPITypes` | 见下表。 |

| API | 原因码 | 代码里的用途 |
|-----|--------|----------------|
| UserDefaults | `CA92.1` | `IMHighlightUserDefaultsTaskStore` 按 userID 缓存已核销任务；`IMHighlightKit` 记录 INS 拼接总开关。只在本 App 内读写。 |

结果图下载到 `Library/Application Support/InmoxHighlight*/<userID>/`，不读取文件时间戳。

## 二进制消费者拿到清单的两个位置

1. **每个 XCFramework 切片内**：`IMHighlightKit.framework/PrivacyInfo.xcprivacy`。
2. **CocoaPods resource bundle** `IMHighlightKit.bundle`：静态链接不会把 framework 目录嵌进 App，清单还放在资源包根目录，随 `[CP] Copy Pods Resources` 进包。

## 宿主仍需自己声明的部分

SDK 只接收宿主传入的图片 `Data`，不直接访问相册或相机。宿主自己选图时按需配置 `NSPhotoLibraryUsageDescription` / `NSCameraUsageDescription`。

IMBaseKit、Moya、ObjectMapper 的隐私清单随它们自己的 pod 进包。

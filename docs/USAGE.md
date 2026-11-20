# IMHighlightKit 使用说明

「精彩时刻」能力 SDK：漫画（`.comic`）与 INS 拼接（`.collage`）任务的创建上传、列表、详情、轮询、结果图落地与本地缓存。无 UI，按 `userID` 隔离。网络层复用 IMBaseKit 的 `IMCommonProvider`，自动带登录 token。

## 安装

```ruby
platform :ios, '15.0'
use_frameworks! :linkage => :static   # dynamic 也可以

target 'YourApp' do
  pod 'IMBaseKit',      :git => 'https://github.com/INMO-X/IMBaseKit.git',      :tag => '0.1.2'
  pod 'IMHighlightKit', :git => 'https://github.com/INMO-X/IMHighlightKit.git', :tag => '0.1.2'
end
```

```swift
import IMBaseKit
import IMHighlightKit
```

## 前置条件

1. 登录成功、token 刷新后调用 `IMUtils.set(uid:token:)`（或 `IMUtils.setAccessToken(_:)`），否则请求不带 `Authorization`。
2. 请求地址取 `IMEnvironmentManager.shared.environment.baseUrlString`。
3. token 过期 / 无效时 IMBaseKit 广播 `.im.expiredToken` / `.im.invalidToken`，刷新与登出由宿主处理。

## 1. 绑定用户并同步

```swift
IMUtils.set(uid: userId, token: accessToken)
IMHighlightKit.shared.configure(userID: userId)   // 切换账号再调一次
IMHighlightKit.shared.sync()                      // 拉未核销 → 下载结果图 → 核销 → 落地本地
```

## 2. 创建任务并上传素材

```swift
// images：原始图片 Data（jpeg / png / heic），SDK 内部压缩为 ≤1MB JPEG
let accepted = IMHighlightKit.shared.createTaskWithUpload(kind: .comic, images: images, region: nil)
if !accepted {
    // 已有任务在生成（漫画与 INS 拼接共用一个名额）
}
```

调用后立即出现一条本地「生成中」占位，后台上传成功后替换为真实任务，每一步都广播 `tasksDidChangeNotification`。

需要自己拿结果时直接用服务：

```swift
let service = IMHighlightKit.shared.service(for: .comic)
service.createTask(images: images, region: .cn) { result in
    switch result {
    case .success(let task):  print(task.taskId, task.status)
    case .failure(let error): print(error)
    }
}
```

## 3. 列表、详情与轮询

```swift
service.fetchTasks(page: 1, size: 20, excludeConsumed: true) { result in
    if case .success(let payload) = result { _ = (payload.tasks, payload.total) }
}
service.fetchTaskDetail(id: taskId) { _ in }

let interval = IMHighlightKit.pollInterval(forImageCount: images.count)
let handle = service.pollTask(id: taskId, interval: interval,
                              onUpdate: { task in },
                              onFinish: { result in })
handle.cancel()   // 页面销毁时务必取消
```

## 4. 展示与监听

```swift
NotificationCenter.default.addObserver(self, selector: #selector(reload),
                                       name: IMHighlightKit.tasksDidChangeNotification, object: nil)

let tasks = IMHighlightKit.shared.allLocalTasks() + IMHighlightKit.shared.allPendingTasks()
let image = task.localImagePath.flatMap { UIImage(contentsOfFile: $0) }   // 优先本地图
```

## 5. 删除、编辑与清理

```swift
let manager = IMHighlightKit.shared.syncManager(for: task.kind)
manager.removePending(id: task.taskId)
manager.deleteLocal(id: task.taskId)
manager.updateSummary(id: task.taskId, title: "新标题", description: "新文案")   // 仅本地
IMHighlightKit.shared.clearLocalData()
```

未核销任务删除前还要调用 `service(for: task.kind).deleteTask(id:)` 删服务端。

## 6. INS 拼接入口

```swift
collageButton.isHidden = !IMHighlightKit.shared.isCollageFeatureEnabled
NotificationCenter.default.addObserver(self, selector: #selector(updateEntry),
                                       name: IMHighlightKit.collageAvailabilityDidChangeNotification, object: nil)
IMHighlightKit.shared.syncManager(for: .collage).refreshConfig { config in
    let allowed = config?.imageCounts(upTo: 9) ?? []
}
```

## 注意事项

- 同步器状态（`pendingTasks`、`hasGeneratingTask`、`createTaskWithUpload` 等）只在主线程读写；回调与通知都在主线程。
- 两类任务的 `taskId` 可能撞号，去重用 `uniqueKey`。
- `outputUrl` 是会过期的签名 URL，不要持久化；已核销任务用 `localImagePath`。
- 二进制是 Release 构建：网络请求日志插件固定为不输出（源码里 `#if DEBUG` 才打开 verbose）。

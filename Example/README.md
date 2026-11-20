# IMHighlightKit Example

可运行 Demo，依赖公开仓 tag `0.1.2` 的 IMBaseKit 和 IMHighlightKit 静态库。

```bash
cd Example
pod install
open IMHighlightKit.xcworkspace
```

选择 scheme **IMHighlightKit_Example**。首页列出本地已核销 / 未核销任务数、生成中名额、漫画最多张数、INS 拼接入口开关和轮询间隔档位，任务变化时自动刷新。不登录也能运行；创建任务需要先用 `IMUtils.set(uid:token:)` 写入登录态。

本地未推送 tag 时，把 Podfile 里的 `:git` 行换成注释中的 `:path`。

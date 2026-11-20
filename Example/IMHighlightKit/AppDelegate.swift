import IMHighlightKit
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 真实接入先 IMUtils.set(uid:token:) 写入登录态，再 configure + sync()。
        IMHighlightKit.shared.configure(userID: "example-user")
        return true
    }
}

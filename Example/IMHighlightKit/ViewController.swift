import IMHighlightKit
import UIKit

/// 按 USAGE 读取本地状态：已核销 / 未核销任务、生成中名额、INS 拼接开关、轮询间隔。
/// 不登录也能运行；创建任务需要宿主先写入登录态。
final class ViewController: UITableViewController {

    private var rows: [(String, String)] = []
    private var observers: [NSObjectProtocol] = []

    init() { super.init(style: .insetGrouped) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "IMHighlightKit"
        for name in [IMHighlightKit.tasksDidChangeNotification,
                     IMHighlightKit.collageAvailabilityDidChangeNotification] {
            observers.append(NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
                self?.reload()
            })
        }
        reload()
    }

    private func reload() {
        let kit = IMHighlightKit.shared
        rows = [
            ("已核销任务（本地）", "\(kit.allLocalTasks().count)"),
            ("未核销任务", "\(kit.allPendingTasks().count)"),
            ("有任务在生成", kit.hasGeneratingTask ? "是" : "否"),
            ("漫画最多张数", "\(kit.service(for: .comic).maxImageCount)"),
            ("INS 拼接入口", kit.isCollageFeatureEnabled ? "开启" : "关闭"),
            ("轮询间隔 1 / 4 / 9 张", [1, 4, 9].map { "\(Int(IMHighlightKit.pollInterval(forImageCount: $0)))s" }.joined(separator: " / "))
        ]
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = rows[indexPath.row].0
        cell.detailTextLabel?.text = rows[indexPath.row].1
        cell.selectionStyle = .none
        return cell
    }
}

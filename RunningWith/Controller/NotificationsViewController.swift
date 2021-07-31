import UIKit

class NotificationsViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tvNotification: UITableView!
    
    // MARK: - Properties
    var notifs: [Notif] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        BDD().getAllNotification { (notif) in
            if let myNotif = notif {
                    if let index = self.notifs.firstIndex(where: {$0.id == myNotif.id}) {
                        self.notifs[index] = myNotif
                    } else {
                        self.notifs.append(myNotif)
                    }
            }
            self.tvNotification.reloadData()
        }
    }
    



}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNotif", for: indexPath) as? NotificationCellTableViewCell
        cell?.notif = self.notifs[indexPath.row]
        cell?.awakeFromNib()
        return cell!
    }
    
    
}

import UIKit

class NotificationCellTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var ivImageRun: UIImageView!
    @IBOutlet weak var lbTitreNotif: UILabel!
    @IBOutlet weak var lbDateNotif: UILabel!
    @IBOutlet weak var lbTextNotif: UILabel!
    
    // MARK: - Properties
    var notif: Notif?
    
    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        if let no = self.notif {
            self.lbTitreNotif.text = no.titre
            self.lbDateNotif.text = DateFormatter.full.string(from: Date(timeIntervalSinceReferenceDate: no.date))
            self.lbTextNotif.text = no.texte
            if let run = no.run {
                self.ivImageRun.download(imageUrl: run.imageUrl)
            }
        } else {
            self.lbTitreNotif.text = ""
            self.lbDateNotif.text = ""
            self.lbTextNotif.text = ""
            self.ivImageRun.image = UIImage(named: "run_default")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

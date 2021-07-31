import UIKit

class RunViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lbTitre: UILabel!
    @IBOutlet weak var lbHost: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var lbSpeed: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var cvRunners: UICollectionView!
    
    // MARK: - Properties
    var participate: Bool {
        if let theRun = run {
            return theRun.runners.contains(where: {$0.id == currentUser.id})
        } else {
            return false
        }
    }
    var run: Run?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor(named: "labelColorPrimary")
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if let theRun = run {
            self.ivImage.download(imageUrl: theRun.imageUrl)
            self.lbTitre.text = theRun.titre
            self.lbHost.text = "with \(theRun.creator.username)"
            self.lbDate.text = DateFormatter.full.string(from: Date(timeIntervalSinceReferenceDate: theRun.date)) 
            self.lbLocation.text = theRun.address
            self.lbDistance.text = "\(theRun.distance)"
            self.lbSpeed.text = "\(theRun.speed)"
            self.lbDescription.text = theRun.description
        }
        self.configBtnDone()
    }
    
    
    // MARK: - Actions
    @IBAction func actionBtnDone(_ sender: UIButton) {
        switch self.btnDone.titleLabel?.text {
        case "Join":
            self.run?.runners.append(currentUser)
            BDD().updateRun(run: self.run!) { (success, message) in
                Alerte().messageSimple(controller: self, titre: "Join Run", message: "you have just joined the race")
                if success ?? false {
                    let notif = Notif(run: self.run!, date: Date().timeIntervalSinceReferenceDate, titre: "Joined", texte: "\(currentUser.username) has just joined your run \(self.run?.titre ?? "")")
                    BDD().sendNotification(id: self.run?.creator.id ?? "", notif: notif)
                    self.configBtnDone()
                }
            }
        case "Leave":
            self.run?.runners.removeAll(where: { (user) -> Bool in
                return currentUser.id == user.id
            })
            BDD().updateRun(run: self.run!) { (success, message) in
                Alerte().messageSimple(controller: self, titre: "Leave Run", message: "you have just leaved the race")
                if success ?? false {
                    let notif = Notif(run: self.run!, date: Date().timeIntervalSinceReferenceDate, titre: "Leave", texte: "\(currentUser.username) has just Leave your run \(self.run?.titre ?? "")")
                    BDD().sendNotification(id: self.run?.creator.id ?? "", notif: notif)
                    self.configBtnDone()
                }
            }
        case "Delete":
            if let theRun = self.run {
                BDD().removeRun(run: theRun) { (success, message) in
                    if success ?? false {
                        let notif = Notif(run: self.run, date: Date().timeIntervalSinceReferenceDate, titre: "Remove", texte: "The run \(self.run?.titre ?? "") in which you participate has been removed.")
                        self.run?.runners.forEach { (user) in
                            BDD().sendNotification(id: user.id, notif: notif)
                        }
                    }
                    Alerte().messageSimple(controller: self, titre: "Delete Run", message: message ?? "") { (action) in
                        if success ?? false {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }

            }
        default:
            break
        }
    }
    
    private func configBtnDone() {
        if let theRun = self.run {
            if theRun.date > Date().timeIntervalSinceReferenceDate {
                self.btnDone.isHidden = false
                if !participate {
                    self.btnDone.backgroundColor = UIColor(named: "labelColorPrimary")
                    self.btnDone.setTitle("Join", for: .normal)
                } else {
                    self.btnDone.backgroundColor = UIColor.systemRed
                    if theRun.creator.id == currentUser.id {
                        self.btnDone.setTitle("Delete", for: .normal)
                    } else {
                        self.btnDone.setTitle("Leave", for: .normal)
                    }
                }
            }
        }
        self.cvRunners.reloadData()
    }
    
}
// MARK: - UICollectionViewDataSource
extension RunViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.run?.runners.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "runnersCell", for: indexPath) as? RunnersCollectionViewCell
        if let myRun = self.run {
            cell?.ivAvatarRunner.download(imageUrl: myRun.runners[indexPath.row].imageUrl)
            cell?.ivAvatarRunner.rounded()

        }
        return cell!
    }
}

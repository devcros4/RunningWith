import UIKit

class RunsViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var scRun: UISegmentedControl!
    @IBOutlet weak var tvRuns: UITableView!
    @IBOutlet weak var aivLoading: UIActivityIndicatorView!
    @IBOutlet weak var lbLoading: UILabel!
    @IBOutlet weak var lbNoRun: UILabel!
    
    // MARK: - Properties
    let runCellId = "RunTableViewCell"
    var runs: [Run] = []
    var runSelected: Run?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvRuns.register(UINib.init(nibName: self.runCellId, bundle: nil), forCellReuseIdentifier: self.runCellId)
        self.tvRuns.rowHeight = 110
        self.getRuns()
        self.navigationController!.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getRuns()
        self.tvRuns.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openRun" {
            if let nextViewController = segue.destination as? RunViewController {
                nextViewController.run = runSelected
            }
        }
        if segue.identifier == "editRun" {
            if let nextViewController = segue.destination as? CreateViewController {
                nextViewController.run = runSelected
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func actionJoinedOrCreated(_ sender: UISegmentedControl) {
        self.getRuns()
    }
    
    // MARK: - Private Methode
    private func getRuns() {
        self.runs = []
        self.tvRuns.isHidden = true
        self.lbNoRun.isHidden = true
        self.aivLoading.isHidden = false
        self.aivLoading.startAnimating()
        self.lbLoading.isHidden = false
        if scRun.selectedSegmentIndex == 0 {
            BDD().getRunsJoinByUser { (theRun) in
                if let run = theRun {
                    if let index = self.runs.firstIndex(where: {$0.id == run.id}) {
                        self.runs[index] = run
                    } else {
                        self.runs.append(run)
                    }
                }
                self.printRuns()
            }
        }
        if scRun.selectedSegmentIndex == 1 {
            BDD().getRunsCreateByUser { (theRun) in
                if let run = theRun {
                    if let index = self.runs.firstIndex(where: {$0.id == run.id}) {
                        self.runs[index] = run
                    } else {
                        self.runs.append(run)
                    }
                }
                self.printRuns()
            }
        }
    }
    
    private func printRuns() {
        self.aivLoading.stopAnimating()
        self.lbLoading.isHidden = true
        if self.runs.isEmpty {
            self.lbNoRun.isHidden = false
        } else {
            self.lbNoRun.isHidden = true
            self.runs = self.runs.sorted(by: {$0.date > $1.date})
            self.tvRuns.isHidden = false
            self.tvRuns.reloadData()
        }
    }

}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension RunsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.runs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.runCellId, for: indexPath) as? RunTableViewCell
        cell?.run = self.runs[indexPath.row]
        cell?.awakeFromNib()
        return cell!
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Runs"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.runSelected = runs[indexPath.row]
        performSegue(withIdentifier: "openRun", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            self.runSelected = self.runs[indexPath.row]
            self.performSegue(withIdentifier: "editRun", sender: nil)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            print(indexPath.row)
            print(self.runs[indexPath.row].titre)
            BDD().removeRun(run: self.runs[indexPath.row]) { (success, message) in
                if success! {
                    let run = self.runs[indexPath.row]
                    let notif = Notif(run: run, date: Date().timeIntervalSinceReferenceDate, titre: "Remove", texte: "The run \(run.titre) in which you participate has been removed.")
                    run.runners.forEach { (user) in
                        BDD().sendNotification(id: user.id, notif: notif)
                    }
                    self.runs.remove(at: indexPath.row)
                    self.tvRuns.deleteRows(at: [indexPath], with: .automatic)
                    Alerte().messageSimple(controller: self, titre: "Success", message: message ?? "")
                } else {
                    Alerte().messageSimple(controller: self, titre: "Error", message: message ?? "Error when deleted the run")
                }
            }
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.scRun.selectedSegmentIndex == 1 {
            return true
        } else {
            return false
        }
    }

}

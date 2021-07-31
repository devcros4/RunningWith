import UIKit
import CoreLocation

class FindViewController: UIViewController {
    
    // MARK: - Properties
    let runCellId = "RunTableViewCell"
    var runs: [Run] = []
    var runSelected: Run?
    let locationManager = CLLocationManager()
    var filterStartDate: Double?
    var filterEndDate: Double?
    var filterDistanceMax: Int?
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lbLoading: UILabel!
    @IBOutlet weak var lbInfoNoRace: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: self.runCellId, bundle: nil), forCellReuseIdentifier: self.runCellId)
        self.tableView.rowHeight = 110
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.navigationController!.navigationBar.prefersLargeTitles = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Request a user’s location once
        locationManager.requestLocation()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openRun" {
            if let nextViewController = segue.destination as? RunViewController {
                nextViewController.run = runSelected
            }
        } else if segue.identifier == "segueFilter" {
            if let nextViewController = segue.destination as? FilterViewController {
                if let startDate = self.filterStartDate {
                    nextViewController.oldStartDate = startDate
                }
                if let endDate = self.filterEndDate {
                    nextViewController.oldEndDate = endDate
                }
                if let distanceMax = self.filterDistanceMax {
                    nextViewController.oldDistanceMax = distanceMax
                }
                nextViewController.completionHandler = { (startDate, endDate, distanceMax) in
                    self.filterDistanceMax = distanceMax
                    self.filterStartDate = startDate
                    self.filterEndDate = endDate
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func unwind( _ seg: UIStoryboardSegue) {}
    
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension FindViewController: UITableViewDelegate, UITableViewDataSource {
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
        return "Runs available"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.runSelected = runs[indexPath.row]
        performSegue(withIdentifier: "openRun", sender: nil)
    }
}
// MARK: - CLLocationManagerDelegate
extension FindViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.runs = []
            BDD().findRuns(location: location, startDate: self.filterStartDate, endDate: self.filterEndDate, distanceMax: self.filterDistanceMax) { (theRun) in
                    if let run = theRun {
                        if let index = self.runs.firstIndex(where: {$0.id == run.id}) {
                            self.runs[index] = run
                        } else {
                            self.runs.append(run)
                        }
                    }
                    self.activityIndicator.stopAnimating()
                    self.lbLoading.isHidden = true
                    if self.runs.isEmpty {
                        self.lbInfoNoRace.isHidden = false
                        self.tableView.isHidden = true
                    } else {
                        self.lbInfoNoRace.isHidden = true
                        self.tableView.isHidden = false
                    }
                self.runs = self.runs.sorted(by: {$0.date < $1.date})
                self.tableView.reloadData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

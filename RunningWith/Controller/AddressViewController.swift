import UIKit
import MapKit

class AddressViewController: UIViewController {
    // MARK: - IBOutlet
    var searchBar = UISearchBar()
    var results: [MKLocalSearchCompletion] = []
    let completer = MKLocalSearchCompleter()
    var completionHandler: ((String) -> Void)?
    
    // MARK: - Properties
    @IBOutlet weak var tvAddress: UITableView!
    
    // MARK: - Cell Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.sizeToFit()
        self.searchBar.placeholder = "Search for places"
        searchBar.delegate = self
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(actionCancel(sender:)))
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = cancelButton
        completer.delegate = self
    }
    
    // MARK: - Actions
    @objc func actionCancel(sender: UIBarButtonItem) {
        dismiss(animated: false, completion: nil)
    }

}
// MARK: - UISearchBarDelegate
extension AddressViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.completer.queryFragment = searchText
    }
    
}

extension AddressViewController: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
        self.tvAddress.reloadData()
    }

}

extension AddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row].title
        cell.detailTextLabel?.text = results[indexPath.row].subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = "\(results[indexPath.row].title) \(results[indexPath.row].subtitle)"
        completionHandler?(address)
        dismiss(animated: false, completion: nil)
    }
    
}

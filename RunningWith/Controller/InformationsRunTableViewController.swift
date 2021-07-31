import UIKit

class InformationsRunTableViewController: UITableViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tfTitreRun: UITextField!
    @IBOutlet weak var dpDateRun: UIDatePicker!
    @IBOutlet weak var btLocationRun: UIButton!
    @IBOutlet weak var tfSpeedRun: UITextField!
    @IBOutlet weak var tfDistanceRun: UITextField!
    @IBOutlet weak var tvDescriptionRun: UITextView!
    
    // MARK: - Properties
    var address: String = ""
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectAddress", let nav = segue.destination as? UINavigationController, let destination = nav.topViewController as? AddressViewController {
            destination.searchBar.text = address
            destination.completer.queryFragment = address
            destination.completionHandler = { newAddress in
                self.address = newAddress
                self.btLocationRun.setTitle(self.address, for: .normal)
            }
        }
    }


}

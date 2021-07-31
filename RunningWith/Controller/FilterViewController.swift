import UIKit

class FilterViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var dpStartDate: UIDatePicker!
    @IBOutlet weak var dpEndDate: UIDatePicker!
    @IBOutlet weak var lbDistanceMax: UILabel!
    @IBOutlet weak var sDistanceMax: UISlider!
    
    // MARK: - Properties
    var oldStartDate: Double?
    var oldEndDate: Double?
    var oldDistanceMax: Int?
    var completionHandler: ((Double, Double, Int) -> Void)?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dpStartDate.minimumDate = oldStartDate != nil ? Date(timeIntervalSinceReferenceDate: oldStartDate!) : Date()
        self.dpEndDate.minimumDate = oldEndDate != nil ? Date(timeIntervalSinceReferenceDate: oldEndDate!) : Date()
        self.sDistanceMax.value = Float(oldDistanceMax != nil ? oldDistanceMax! : 10)
        self.lbDistanceMax.text = "\(Int(self.sDistanceMax.value)) Km"
    }
    
    // MARK: - Actions
    @IBAction func actionSwitchDistance(_ sender: UISlider) {
        self.lbDistanceMax.text = "\(Int(sender.value)) Km"
    }
    
    @IBAction func actionDone(_ sender: UIButton) {
        let dMax = sDistanceMax.value >= Float(0) ? Int(sDistanceMax.value) : 40
        completionHandler?(dpStartDate.date.timeIntervalSinceReferenceDate, dpEndDate.date.timeIntervalSinceReferenceDate, dMax)
        performSegue(withIdentifier: "back", sender: self)
    }
    
}

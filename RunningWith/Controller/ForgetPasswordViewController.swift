import UIKit

class ForgetPasswordViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tfEmail: UITextField!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tfEmail.addBottomBorderWithColor(color: UIColor(named: "separatorColor")!, width: 1)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func continueDidTouch(_ sender: UIButton) {
        BDD().resetPassword(email: tfEmail.text ?? "") { (success, message) in
            Alerte().messageSimple(controller: self, titre: "Reset Password", message: message ?? "")
        }
    }

    @IBAction func closeDidTouch(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

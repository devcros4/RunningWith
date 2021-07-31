import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
        
    // MARK: - Outlets
    @IBOutlet weak var tfEmailAddress: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var stackViewPassword: UIStackView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tfEmailAddress.addBottomBorderWithColor(color: UIColor(named: "separatorColor")!, width: 1)
        stackViewPassword.addBottomBorderWithColor(color: UIColor(named: "separatorColor")!, width: 1)
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    @IBAction func signInDidTouch(_ sender: UIButton) {
        guard let email = tfEmailAddress.text, let password = tfPassword.text, !email.isEmpty, !password.isEmpty else {
            return
        }
        BDD().signIn(email: email, password: password) { (user, error) in
            if let error = error, user == nil {
                Alerte().messageSimple(controller: self, titre: "Erreur", message: error.localizedDescription)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeDidTouch(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

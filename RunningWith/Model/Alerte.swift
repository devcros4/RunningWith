import UIKit
import FirebaseAuth

class Alerte {
    
    /// present a simple alert action
    /// - Parameters:
    ///   - controller: where you want present
    ///   - titre: titre of alert
    ///   - message: message of alert
    ///   - completion: action after pressed button "ok"
    func messageSimple(controller: UIViewController, titre: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alerte = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: completion)
        alerte.addAction(ok)
        controller.present(alerte, animated: true, completion: nil)
    }
    
    
    /// present confirmation dialog for sure you want to logout
    /// - Parameter controller: where present alert
    func logOut(controller: UIViewController) {
        let alerte = UIAlertController(title: "Are you sure you want to sign out?", message: nil, preferredStyle: .alert)
        let oui = UIAlertAction(title: "YES", style: .default) { (action) in
            BDD().signOut { (success, error) -> Void in
                if success ?? false {
                    controller.dismiss(animated: true, completion: nil)
                } else {
                    print(error?.debugDescription ?? "")
                }
            }
        }
        let non = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        alerte.addAction(oui)
        alerte.addAction(non)
        controller.present(alerte, animated: true, completion: nil)
    }
    
}

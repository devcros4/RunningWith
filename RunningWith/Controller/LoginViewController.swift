//
//  LoginViewController.swift
//  RunningWith
//
//  Created by DELCROS Jean-baptiste on 04/01/2021.
//  Copyright © 2021 DELCROS Jean-baptiste. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
        
    // MARK: - Outlets
    @IBOutlet weak var tfEmailAddress: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func signInDidTouch(_ sender: UIButton) {
        guard let email = tfEmailAddress.text, let password = tfPassword.text, !email.isEmpty, !password.isEmpty else {
            return
        }
        BDD().signIn(email: email, password: password) { (user, error) in
            if let error = error, user == nil {
                Alerte().erreurSimple(controller: self, message: error.localizedDescription)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeDidTouch(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    //Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

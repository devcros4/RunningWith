//
//  JoinViewController.swift
//  RunningWith
//
//  Created by DELCROS Jean-baptiste on 07/12/2020.
//  Copyright © 2020 DELCROS Jean-baptiste. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfEmailAddress: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    // to store the current active textfield
    var activeTextField : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(Self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(Self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        // if active text field is not nil
        if let activeTextField = activeTextField {
            
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            // if the bottom of Textfield is below the top of keyboard, move up
            if bottomOfTextField > topOfKeyboard {
                self.view.frame.origin.y = 0 - (bottomOfTextField - topOfKeyboard)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
    
    @IBAction func joinDidTouch(_ sender: Any) {
        guard
            let name = tfName.text,
            let lastName = tfLastName.text,
            let username = tfUsername.text,
            let email = tfEmailAddress.text,
            let password = tfPassword.text else {
            return
        }
        
        if name.isEmpty || lastName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty {
            Alerte().erreurSimple(controller: self, message: "Please enter all input felds")
        } else {
            BDD().usernameAlreadyExiste(username: username) { [unowned self] (existe, errorMessage) -> Void in
                if let existe =  existe, existe {
                    Alerte().erreurSimple(controller: self, message: errorMessage ?? "")
                } else {
                    BDD().createUserForAuthentification(email: email, password: password) { [unowned self] (success, error) in
                        if let erreur = error {
                            Alerte().erreurSimple(controller: self, message: erreur.localizedDescription)
                        } else {
                            let user = User(email: email, username: username, nom: name, prenom: lastName, imageUrl: "")
                            BDD().createOrUpdateUser(user: user) { (user) -> Void in
                                if let user = user {
                                    currentUser = user
                                }
                            }
                            dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func closeDidTouch(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
// MARK: - UITextFieldDelegate
extension JoinViewController: UITextFieldDelegate {
    
    //Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // when user select a textfield, this method will be called
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set the activeTextField to the selected textfield
        self.activeTextField = textField
    }
    
    // when user click 'done' or dismiss the keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
}

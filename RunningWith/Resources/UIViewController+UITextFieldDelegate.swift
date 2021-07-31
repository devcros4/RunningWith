import Foundation
import UIKit

// MARK: - UITextFieldDelegate
extension UIViewController: UITextFieldDelegate {
        
    /// Called when 'return' key pressed. close keybord
    /// - Parameter textField: textfield
    /// - Returns: true
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
}

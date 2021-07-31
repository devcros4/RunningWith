import Foundation
import UIKit
/// Extension of UIButton
extension UIButton {
    
    /// add delay for presse a second time button, by default its one second
    /// - Parameter seconds: <#seconds description#>
    func preventRepeatedPresses(inNext seconds: Double = 1) {
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            self.isUserInteractionEnabled = true
        }
    }
}

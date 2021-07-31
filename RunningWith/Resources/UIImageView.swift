import Foundation
import UIKit
import SDWebImage

/// Extension of UIImageView
extension UIImageView {
    
    
    /// dowload the image in parameter with framwork SDWebImage and put image in imageView otherwise default image is "user"
    /// - Parameter imageUrl: <#imageUrl description#>
    func download(imageUrl: String?) {
        image = UIImage(named: "user")
        guard let string = imageUrl, string != "" , let url = URL(string: string) else { return }
        sd_setImage(with: url, completed: nil)
    }
    
}

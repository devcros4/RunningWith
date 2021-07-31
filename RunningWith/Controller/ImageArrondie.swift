import UIKit
/// class for have rounded image
class ImageArrondie: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// rounded the current image
    func rounded() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = bounds.width / 2
    }

}

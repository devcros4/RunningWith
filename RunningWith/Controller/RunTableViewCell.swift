import UIKit
import Foundation
import MapKit

class RunTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var run: Run?
    
    // MARK: - IBOutlet
    @IBOutlet weak var lbTitre: UILabel!
    @IBOutlet weak var lbDateTime: UILabel!
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var lbSpeed: UILabel!
    @IBOutlet weak var lbRunners: UILabel!
    @IBOutlet weak var ivRun: UIImageView!
    
    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let myRun = self.run else { return }
        self.ivRun.download(imageUrl: myRun.imageUrl)
        self.lbTitre.text = myRun.titre
        self.lbDateTime.text = DateFormatter.full.string(from: Date(timeIntervalSinceReferenceDate: myRun.date)) 
        self.lbDistance.text = "\(myRun.distance)"
        self.lbSpeed.text = "\(myRun.speed)"
        self.lbRunners.text = "\(myRun.runners.count)"
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

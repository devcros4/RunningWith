//
//  RunTableViewCell.swift
//  RunningWith
//
//  Created by DELCROS Jean-baptiste on 18/01/2021.
//  Copyright © 2021 DELCROS Jean-baptiste. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class RunTableViewCell: UITableViewCell {
    
    var run: Run?
    
    @IBOutlet weak var lbTitre: UILabel!
    @IBOutlet weak var lbDateTime: UILabel!
    @IBOutlet weak var lbPlace: UILabel!
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var lbSpeed: UILabel!
    @IBOutlet weak var lbTimer: UILabel!
    @IBOutlet weak var lbLevel: UILabel!
    @IBOutlet weak var mpLocation: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let myRun = self.run else { return }
        self.lbTitre.text = myRun.titre
        self.lbDateTime.text = "\(myRun.date)"
        self.lbPlace.text = "Mont-De-Marsan"
        self.lbDistance.text = "\(myRun.distance)"
        self.lbSpeed.text = "\(myRun.speed)"
        self.lbTimer.text = "\(myRun.duration)"
        self.lbLevel.text = myRun.level
//        self.mpLocation.
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

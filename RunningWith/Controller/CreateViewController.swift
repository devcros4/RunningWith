//
//  CreateViewController.swift
//  RunningWith
//
//  Created by DELCROS Jean-baptiste on 09/01/2021.
//  Copyright © 2021 DELCROS Jean-baptiste. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

    var run: Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action
    @IBAction func trashDidTouch(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func saveDidTouch(_ sender: UIButton) {
        if let theRun = self.run {
            // update therun
            // update in firebase
        } else {
           // create run
            // create in firebase
        }
    }
    
}

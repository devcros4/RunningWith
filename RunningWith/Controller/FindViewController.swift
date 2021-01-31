//
//  FindViewController.swift
//  RunningWith
//
//  Created by DELCROS Jean-baptiste on 09/01/2021.
//  Copyright © 2021 DELCROS Jean-baptiste. All rights reserved.
//

import UIKit

class FindViewController: UIViewController {
    
    // MARK: 
    let runCellId = "RunTableViewCell"
    var runs: [Run] = []
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lbLoading: UILabel!
    @IBOutlet weak var lbInfoNoRace: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: self.runCellId, bundle: nil), forCellReuseIdentifier: self.runCellId)
        self.tableView.rowHeight = 110
        self.tableView.separatorColor = UIColor.clear
        self.getRuns()
    }
    
    private func getRuns() {
        self.runs = []
        self.tableView.isHidden = true
        self.lbInfoNoRace.isHidden = true
        self.activityIndicator.startAnimating()
        self.lbLoading.isHidden = false
        BDD().getAllRuns { (runsRecover) -> Void in
            if let runsReal = runsRecover {
                print(runsReal)
                self.runs = runsReal
                print(self.runs.count)
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.lbLoading.isHidden = true
            }
        }
    }
    
    
}

extension FindViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.runs.isEmpty {
            tableView.isHidden = true
            self.lbInfoNoRace.isHidden = false
        }
        return self.runs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.runCellId, for: indexPath) as? RunTableViewCell
        cell?.run = self.runs[indexPath.row]
        cell?.awakeFromNib()
        return cell!
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Runs"
    }
}

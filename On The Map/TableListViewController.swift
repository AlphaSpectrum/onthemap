//
//  TableListViewController.swift
//  On The Map
//
//  Created by Alan Campos on 8/1/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation
import UIKit

class TableListViewController: UITableViewController {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate

    var connection: CConnection?
    var users: [[String : AnyObject]]?
    var userCell = [UITableViewCell]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        users = delegate.userArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let user = users?.count {
            return user
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell")
        let selectedUser = users?[indexPath.row]
        
        if let firstName = selectedUser?["firstName"] as? String,
            let lastName = selectedUser?["lastName"] as? String,
            let mediaURL = selectedUser?["mediaURL"] as? String {
            cell?.textLabel?.text = "\(firstName) \(lastName)"
            cell?.detailTextLabel?.text = "\(mediaURL)"
            userCell.append(cell!)
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let toOpen = userCell[indexPath.row].detailTextLabel?.text {
            if let url = URL(string: toOpen) {
                let app = UIApplication.shared
                app.open(url, options: [UIApplicationOpenURLOptionUniversalLinksOnly: toOpen]) { _ in }
            }
        }
    }
}

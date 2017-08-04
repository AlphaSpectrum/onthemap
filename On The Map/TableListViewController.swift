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
    var selectedCell = [UITableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connection = delegate.connection
        users = delegate.userArray?["results"] as? [[String : AnyObject]]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell")
        let selectedUser = users?[indexPath.row]
        
        if let firstName = selectedUser?["firstName"] as? String,
            let lastName = selectedUser?["lastName"] as? String,
            let mediaURL = selectedUser?["mediaURL"] as? String {
            cell?.textLabel?.text = "\(firstName) \(lastName)"
            cell?.detailTextLabel?.text = "\(mediaURL)"
            selectedCell.append(cell!)
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        if let toOpen = selectedCell[indexPath.row].detailTextLabel?.text {
            if let url = URL(string: toOpen) {
                app.open(url, options: [UIApplicationOpenURLOptionUniversalLinksOnly: toOpen]) { _ in }
            }
        }
    }
}

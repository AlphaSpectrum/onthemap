//
//  ListTableViewController.swift
//  The Map
//
//  Created by Alan Campos on 8/12/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation
import UIKit

class ListTableViewController: UITableViewController, UIUserFeedback {
    
    let cellReuseIdentifier = "ListTableCell"
    let activity = UIActivityIndicatorView()
    
    var userCell = [UITableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func refresh(_ sender: Any) {
        getStudents()
        self.tableView.reloadData()
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        ConnectionHandler.shared.instance.logout() {
            success, errorMessage in
            if success! {
                performUIUpdatesOnMain { self.dismiss(animated: true, completion: nil) }
            } else {
                performUIUpdatesOnMain { self.alertUser(self, title: "Error", message: errorMessage!, actionName: "Dismiss", actionHandler: nil) }
            }
        }
    }
    
    private func getStudents() {
        displayActivityIndicator(viewController: self, activityIndicator: activity, isHidden: false)
        ConnectionHandler.shared.instance.getStudentInformation() {
            students, errorMessage in
            if errorMessage == nil {
                StudentModel.shared.students = students
            } else {
                performUIUpdatesOnMain { self.alertUser(self, title: "Error", message: errorMessage!, actionName: "Dismiss", actionHandler: nil) }
            }
            performUIUpdatesOnMain { self.displayActivityIndicator(viewController: self, activityIndicator: self.activity, isHidden: true) }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let studentCount = StudentModel.shared.students {
            return studentCount.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        let selectedStudent = StudentModel.shared.students[indexPath.row]
        cell?.textLabel?.text = "\(selectedStudent.name.first) \(selectedStudent.name.last)"
        cell?.detailTextLabel?.text = selectedStudent.mediaURL
        userCell.append(cell!)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let toOpen = userCell[indexPath.row].detailTextLabel?.text {
            if let url = URL(string: toOpen) {
                let app = UIApplication.shared
                app.open(url, options: [UIApplicationOpenURLOptionUniversalLinksOnly: toOpen]) {
                    success in
                    if !success {
                        performUIUpdatesOnMain {
                            self.alertUser(self, title: "", message: "Not a valid URL.", actionName: "Dismiss", actionHandler: nil)
                        }
                    }
                }
            }
        }
    }
}

//
//  SpecificMessageTableViewController.swift
//  Social-Feedback-App
//
//  Created by Darshan Kalola on 8/7/17.
//  Copyright © 2017 Darshan Kalola. All rights reserved.
//

import UIKit
import Firebase

class SpecificMessageTableViewController: UITableViewController {

    // MARK: — Model
    var userModel: SendingUserModel!
    var messageConstant = MessageConstants()
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentGenre = userModel.genreOfMessage
        return messageConstant.allBasicGenreMessage[currentGenre!]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! SpecificMessageTableViewCell
        
        let specificMessageArray = [String](messageConstant.allBasicGenreMessage[userModel.genreOfMessage!]!)
        
        cell.cellLabel.text = specificMessageArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // We want to send the message to the given account, and return back to the home screen
        let sendingID = userModel.userID
        let uniqueIDMessage = NSUUID().uuidString
        
        userModel.specificMessage = messageConstant.allBasicGenreMessage[userModel.genreOfMessage!]?[indexPath.row]
        
        // Allow user to confirm message one last time
        confirmMessage(uniqueIDMessage, sendingID: sendingID!, forIndexPath: indexPath)
    }
    
    // MARK: - Alerts
    func confirmMessage(_ uniqueID: String, sendingID: String, forIndexPath: IndexPath) {
        let alertController = UIAlertController(title: "Confirm", message: "Are you sure you wish to send this message?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            // Upload that message to firebase with key of the sending ID
            let ref = FIRDatabase.database().reference().child("user-messages").child(sendingID)
            let valuesDict = [uniqueID: self.userModel.specificMessage!]
            ref.updateChildValues(valuesDict) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.showConfirmationMessage()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true) { 
            self.tableView.deselectRow(at: forIndexPath, animated: true)
        }
    }
    
    func showConfirmationMessage() {
        let alert = UIAlertController(title: "Message Sent!", message: nil, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        perform(#selector(dismissConfirmationMessage), with: nil, afterDelay: 1.0)
    }
    
    func dismissConfirmationMessage() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the size for the rows
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
}

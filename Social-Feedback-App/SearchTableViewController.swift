//
//  SearchTableViewController.swift
//  Social-Feedback-App
//
//  Created by Darshan Kalola on 8/9/17.
//  Copyright © 2017 Darshan Kalola. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import Firebase
import FirebaseAuth

class SearchTableViewController: UITableViewController, CNContactPickerDelegate {

    // MARK: - Constants
    private let genreSegue = "Genre Segue"
    private let logoutSegue = "Logout Segue"
    private let alertTitle = "Authorize Contacts"
    private let phoneNumberDatabaseNode = "phoneNumbersToUserID"
    private let cellIdentifier = "Message Cell"
    
    // MARK: - Model
    var userModel = SendingUserModel()
    var allUserPhoneNumbers = [String : String]()
    var currUserMessages = [String]()
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        // Load all of the user phone numbers
        let ref = FIRDatabase.database().reference().child(phoneNumberDatabaseNode)
        
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : String] {
                self.allUserPhoneNumbers[snapshot.key] = dictionary["userID"]
            }
        }, withCancel: nil)
        
        // Load all of the users incoming messages into model
        if let currentID = FIRAuth.auth()?.currentUser?.uid {
            let messagesRef = FIRDatabase.database().reference().child("user-messages").child(currentID)
            
            messagesRef.observe(.childAdded, with: { (snapshot) in
                // Upload all user strings to curr user messages
                let eachString = snapshot.value as? String
                self.currUserMessages.append(eachString!)
                self.tableView.reloadData()
            }, withCancel: nil)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    // MARK: - Button Responses
    // Intializes contact selection when button is pressed
    @IBAction func showContacts(_ sender: UIButton) {
        authorizeContactUsage()
    }
    
    @IBAction func logout(_ sender: UIButton) {
        // Log out of fire base
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print(error)
        }
        
        performSegue(withIdentifier: logoutSegue, sender: nil)
    }
    
    // Authorizess contact usage and proceeds, or proceeds directly if authorized
    private func authorizeContactUsage() {
        let entityType = CNEntityType.contacts
        let authStatus = CNContactStore.authorizationStatus(for: entityType)
        
        // If has not been authorized
        if authStatus == CNAuthorizationStatus.notDetermined {
            let contactStore = CNContactStore.init()

            contactStore.requestAccess(for: entityType, completionHandler: { (success, nil) in
                if success {
                    self.openContacts()
                }
                else {
                    // Cmon, bro, you need to authorize
                    self.alertUserThatTheyMustAuthorize()
                }
            })
        } else if authStatus == CNAuthorizationStatus.authorized {
            // Begin contact selection
            openContacts()
        } else {
            alertUserThatTheyMustAuthorize()
        }
    }
    
    // Alerts the user that they must authorize use of contacts to proceed with this app, as it is necessary
    func alertUserThatTheyMustAuthorize() {
        let alert = UIAlertController(title: alertTitle, message: "You must authorize your contacts in settings to continue!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        // Create alert to go to settings
        let settingsAction = UIAlertAction(title: "Settings", style: .cancel) { (alert) in
            let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
            
            UIApplication.shared.open(settingsURL!, options: [:], completionHandler: { (success) in
                if !success {
                    print("did not open")
                } else {
                    print("opened")
                }
            })
        }
        
        alert.addAction(alertAction)
        alert.addAction(settingsAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Presents contacts to user selection
    private func openContacts() {
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    // Dismisses contact selection
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Checks if the user you are going to send the message to has a valid account on Uncoated
    func doesRecipientUserHaveAccount(withPhoneNumber phoneNumber: CNPhoneNumber) {
        let phoneNumberString = phoneNumber.stringValue
        
        // Remove dashes from the number
        let phoneNumberStringArray = phoneNumberString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let phoneNumberStringParsed = phoneNumberStringArray.joined(separator: "")
        
        if allUserPhoneNumbers.index(forKey: phoneNumberStringParsed) != nil {
            userModel.hasAppAccount = true
            userModel.userID = allUserPhoneNumbers[phoneNumberStringParsed]
        } else {
            userModel.hasAppAccount = false
        }
    
        if userModel.hasAppAccount! {
            print("User has account")
            print(userModel.userID!)
        } else {
            print("Does not have account")
        }
    }
    
    // When user selects a contact
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let contactFirstName = contact.givenName
        let contactLastName = contact.familyName
        
        let contactFullName = contactFirstName + " " + contactLastName
        
        // Selects the first number from a contact
        let contactNumber = contact.phoneNumbers[0].value
        
        // Generate the model
        userModel.userName = contactFullName
        userModel.userNumber = contactNumber
        
        doesRecipientUserHaveAccount(withPhoneNumber: contactNumber)
        
        // If user doesnt have account
        if !(userModel.hasAppAccount!) {
            dismiss(animated: true, completion: nil)
            userDoesNotHaveAccount()
            return
        }
        // Segues to genre picker!
        performSegue(withIdentifier: genreSegue, sender: nil)
    }
    
    func userDoesNotHaveAccount() {
        // Alert the user that the receipient must have an account as of right now
        let alertController = UIAlertController(title: "Error", message: "Recipient does not have a registered account on Uncoated :(", preferredStyle: .alert)
        
        let cancelAlert = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alertController.addAction(cancelAlert)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set the next model if proceeds segue
        if segue.identifier == genreSegue {
            let nextVC = segue.destination as! GenresTableTableViewController
            nextVC.userModel = userModel
        }
    }
    
    // MARK: - Loading in messages
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currUserMessages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!MyMessagesCellTableViewCell
        
        let currentMessage = currUserMessages[indexPath.row]
        cell.messageLabel.text = currentMessage
        
        return cell
    }
}

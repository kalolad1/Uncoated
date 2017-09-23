//
//  GenresTableTableViewController.swift
//  Social-Feedback-App
//
//  Created by Darshan Kalola on 8/6/17.
//  Copyright © 2017 Darshan Kalola. All rights reserved.
//

import UIKit

class GenresTableTableViewController: UITableViewController {

    // MARK: — Model
    var userModel: SendingUserModel?
    
    // Decides which type of genres and messages to present to the user
    private var messegeConstants = MessageConstants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messegeConstants.allBasicGenreMessage.keys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreTitle", for: indexPath)
        
        // Set the correct genre message for the title of the cell
        let keysArray = [String](messegeConstants.allBasicGenreMessage.keys)
        cell.textLabel?.text = keysArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update model and segue
        let genreOfSelectedMessage = tableView.cellForRow(at: indexPath)?.textLabel?.text
        userModel?.genreOfMessage = genreOfSelectedMessage
        
        // When selected, will segue to pick specific message
        performSegue(withIdentifier: "Show Message", sender: nil)
    }

    // MARK: — Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SpecificMessageTableViewController
        nextVC.userModel = userModel
    }
}

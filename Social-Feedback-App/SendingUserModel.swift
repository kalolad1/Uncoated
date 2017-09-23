//
//  SendingUserModel.swift
//  Social-Feedback-App
//
//  Created by Darshan Kalola on 8/6/17.
//  Copyright © 2017 Darshan Kalola. All rights reserved.
//

import Foundation
import Contacts
import Firebase

public class SendingUserModel {
    
    var userName: String?
    var userNumber: CNPhoneNumber?
    var userID: String?
    var hasAppAccount: Bool?
    var genreOfMessage: String? 
    var specificMessage: String?
}

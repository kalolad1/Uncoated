//
//  HandleLoginErrors.swift
//  Social-Feedback-App
//
//  Created by Darshan Kalola on 9/5/17.
//  Copyright © 2017 Darshan Kalola. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

extension SignInViewController {
    
    // Handles which error message should be displayed to the user during login/register phase
    func handleError(withError error: Error?) {
        if let codeErr = FIRAuthErrorCode(rawValue: (error!._code)) {
            var errorMessageTitle = ""
            var errorMessage = ""
            
            switch codeErr {
            case .errorCodeEmailAlreadyInUse:
                errorMessageTitle = "Email already in use."
                errorMessage = "Someone has already registered with this email. Please try another email."
                
            case .errorCodeUserNotFound:
                errorMessageTitle = "User not found"
                errorMessage = "This email is not registered to any current users. Please try again with another email."
                
            case .errorCodeInvalidEmail:
                errorMessageTitle = "Incorrect email"
                errorMessage = "The email you entered is incorrect. Please check your email and try again."
                
            case .errorCodeWrongPassword:
                errorMessageTitle = "Incorrect password"
                errorMessage = "The password you entered is incorrect. Please try again."
                
            default:
                errorMessageTitle = "An undefined error has occured"
                errorMessage = "Please restart the app and try again."
            }
            showErrorMessage(withTitle: errorMessageTitle, message: errorMessage)
        }
    }

    func showErrorMessage(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let tryAgainOption = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        
        alertController.addAction(tryAgainOption)
        
        present(alertController, animated: true, completion: nil)
    }
}



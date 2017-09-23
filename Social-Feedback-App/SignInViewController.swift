//
//  SignInViewController.swift
//  Social-Feedback-App
//
//  Created by Darshan Kalola on 8/8/17.
//  Copyright © 2017 Darshan Kalola. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {

    // Constants
    private let loginSegue = "Login Segue"
    private let loginButtonText = "Login"
    private let registerButtonText = "Register"
    
    // Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
   
    // Create register/login button
    lazy var loginAndRegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textColor = UIColor.white
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(loginOrRegister), for: .touchUpInside)
        return button
    }()
    
    // MARK: - UITextField delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Setup
    override func viewDidLoad() {
        // Set the register button to a fixed with
        super.viewDidLoad()
        
        view.addSubview(loginAndRegisterButton)
        setUpLoginAndRegisterButton()
    }
    
    // Prevents rotation
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FIRAuth.auth()?.currentUser != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: self.loginSegue, sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Fades in the login/register text fields
        UIView.animate(withDuration: 1.5) { 
            self.email.alpha = 1.0
            self.phoneNumber.alpha = 1.0
            self.password.alpha = 1.0
        }
    }
    
    func setUpLoginAndRegisterButton() {
        loginAndRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginAndRegisterButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginAndRegisterButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20).isActive = true
    }
    
    // Actions
    @IBAction func handleSwitch(_ sender: UISegmentedControl) {
        // Clears text field when we switch from login mode to register mdoe
        email.text = ""
        password.text = ""
        phoneNumber.text = ""
    }
   
    func loginOrRegister(_ sender: UIButton) {
        // Login
        if segmentedControl.selectedSegmentIndex == 0 {
            initiateLogin()
        }
        // Register
        else {
            initiateRegister()
        }
    }
    
    func initiateLogin() {
        guard let userEmail = email.text, email.text != "", let userPassword = password.text, password.text != "" else {
            print("Invalid login information")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: userEmail, password: userPassword, completion: { (user, error) in
            if error != nil {
                print(error!)
                self.handleError(withError: error)
                return
            } else {
                // Login successfuly
                self.performSegue(withIdentifier: self.loginSegue, sender: nil)
            }
        })
    }
    
    func initiateRegister() {
        // Ensure user has entered valid information
        guard let userEmail = email.text, email.text != "", let userPassword = password.text, password.text != "", let userPhoneNumber = phoneNumber.text, phoneNumber.text != "" else {
            print("Invalid register information")
            return
        }
        
        // Create the user
        FIRAuth.auth()?.createUser(withEmail: userEmail, password: userPassword, completion: { (user, error) in
            if error != nil {
                self.handleError(withError: error)
                return
            }
            
            let ref = FIRDatabase.database().reference()
            let values = ["email" : userEmail, "phone number" : userPhoneNumber]
            
            let userUID = FIRAuth.auth()?.currentUser?.uid
            let userReference = ref.child("user").child(userUID!)
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print("Here is the error name: \(error!)")
                    return
                }
            })
            
            // Update phoneNumbersToUserID child to add the new user
            let phoneNumberToIDRef = ref.child("phoneNumbersToUserID").child(userPhoneNumber)
            let userIDValues = ["userID" : userUID!]
            
            phoneNumberToIDRef.updateChildValues(userIDValues, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
            })
            
            // Segue to search VC
            self.performSegue(withIdentifier: self.loginSegue, sender: nil)
        })
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        // Changes the title of the login/register button according to toggled
        // Removes the phone number text field for login
        loginAndRegisterButton.setTitle(segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex), for: .normal)
        
        // Login state
        if sender.selectedSegmentIndex == 0 {
            phoneNumber.isHidden = true
        }
        // Register state
        else {
            phoneNumber.isHidden = false
        }
    }
}

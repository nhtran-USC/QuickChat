//
//  SignUpViewController.swift
//  QuickChat
//
//  Created by Nguyen Tran on 7/4/22.
//

import UIKit
import FirebaseAuth
import Firebase

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // keyboard started
        
        setUpTextFieldAndButton()

    }
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passWordTextField: UITextField!

    @IBOutlet weak var signInButton: UIButton!
    

    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passWordTextField.text!){ result, error in
            if let error = error {
                let alertMessage = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Try Again", style: .cancel) { action in
                    return
                }
                alertMessage.addAction(okButton)
                self.present(alertMessage, animated: true, completion: nil)
                    
            }
            else {
                // move to Home screen
                self.performSegue(withIdentifier: K.Segue.signInToHome, sender: nil)
    
            }
        }
    }
    
}

extension SignInViewController: UITextFieldDelegate {
    
    
    func setUpTextFieldAndButton() {
        signInButton.layer.cornerRadius = signInButton.frame.height / 2.0
        passWordTextField.textContentType = .oneTimeCode
        emailTextField.becomeFirstResponder()
        self.emailTextField.delegate = self
        self.passWordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == emailTextField) {
            self.passWordTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return false
    }
    

}


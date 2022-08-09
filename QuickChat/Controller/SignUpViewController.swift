//
//  SignUpViewController.swift
//  QuickChat
//
//  Created by Nguyen Tran on 7/4/22.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // keyboard started
        
        setUpTextFieldAndButton()
        createDatePicker()
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var nameVerifyLabel: UILabel!
    
    @IBOutlet weak var emailVerifyLabel: UILabel!
    
    @IBOutlet weak var passwordVerifyLabel: UILabel!
    
    @IBOutlet weak var dateOfBirthVerifyLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var nameIsVerified = false
    var emailIsVerified = false
    var passwordIsVerified = false
    var dateOfBirthIsVerified = false
    
    
    let datePicker = UIDatePicker()
    
    @IBAction func signUpButtonDidTap(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passWordTextField.text!) { result, error in
            if let error = error {
                let alertMessage = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Try Again", style: .cancel) { action in
                    return
                }
                alertMessage.addAction(okButton)
                self.present(alertMessage, animated: true, completion: nil)
                    
            }
            else {
                // create new user database
                if let user = Auth.auth().currentUser {
                    let ref = Firestore.firestore().collection("Users").document(user.uid)
                    ref.setData([
                        "name" : self.nameTextField.text!,
                        "email" : self.emailTextField.text!,
                        "date of birth" : self.dateOfBirthTextField.text!
                    ])
                    // move to Home screen
                    self.performSegue(withIdentifier: K.Segue.signUpToHome, sender: nil)
                }
            }
        }
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    
    func createDatePicker() {
        // toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        // Done button
        let nextBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(nextBarButtonDidTap))
//        nextBtn.isEnabled = false
        toolBar.setItems([nextBarButton], animated: true)
        
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date
        // Upcast today date
        datePicker.maximumDate = NSDate() as Date
        
        // add Date picker
        dateOfBirthTextField.inputAccessoryView = toolBar
        dateOfBirthTextField.inputView = datePicker
    }
    
    @objc func nextBarButtonDidTap() {
        
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d, yyyy")
        dateOfBirthTextField.text = dateFormatter.string(from: date)
        verifyAndUpdateDateOfBirthLabel()
        checkSignUpButton()
        view.endEditing(true)
    }
    
    func setUpTextFieldAndButton() {
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2.0
        signUpButton.isEnabled = false
        passWordTextField.textContentType = .oneTimeCode
        nameTextField.becomeFirstResponder()
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.dateOfBirthTextField.delegate = self
        self.passWordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == nameTextField) {
            verifyAndUpdateNameLabel()
            self.emailTextField.becomeFirstResponder()
        }
        else if (textField == emailTextField) {
            verifyAndUpdateEmailLabel()
            self.passWordTextField.becomeFirstResponder()
        }
        else if (textField == passWordTextField) {
            verifyAndUpdatePasswordLabel()
            self.dateOfBirthTextField.becomeFirstResponder()
        }
        else {
            verifyAndUpdateDateOfBirthLabel()
            textField.resignFirstResponder()
        }
        return false
    }
    
    func verifyAndUpdateNameLabel() {
        if let name = nameTextField.text, name != ""{
            nameVerifyLabel.text = "👍🏻"
            nameIsVerified = true
        }
        else {
            nameVerifyLabel.text = "👎🏻"
            nameIsVerified = false
        }
    }
    
    func verifyAndUpdateEmailLabel() {
        let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"

        let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
        
        if let email = emailTextField.text, email != "" {
            if(emailValidationPredicate.evaluate(with: email)) {
                emailVerifyLabel.text = "👍🏻"
                emailIsVerified = true
            }
            else {
                emailVerifyLabel.text = "👎🏻"
                emailIsVerified = false
            }
        }
        else {
            emailVerifyLabel.text = "👎🏻"
            emailIsVerified = false
        }
    }
    
//    func verifyAndUpdatePasswordLabel() {
//        let passwordValidationRegex = "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
//        let passwordValidationPreficate = NSPredicate(format: "SELF MATCHES %@", passwordValidationRegex)
//        if let password = passWordTextField.text, password != "" {
//            if(passwordValidationPreficate.evaluate(with: password)) {
//                passwordVerifyLabel.text = "👍🏻"
//                passwordIsVerified = true
//            }
//            else {
//                passwordVerifyLabel.text = "👎🏻"
//                passwordIsVerified = false
//            }
//        }
//        else {
//            passwordVerifyLabel.text = "👎🏻"
//            passwordIsVerified = false
//        }
//    }
    
    func verifyAndUpdatePasswordLabel() {
        if let password = passWordTextField.text, password != ""{
            passwordVerifyLabel.text = "👍🏻"
            passwordIsVerified = true
        }
        else {
            passwordVerifyLabel.text = "👎🏻"
            passwordIsVerified = false
        }
    }
    
    func verifyAndUpdateDateOfBirthLabel() {
        if let date = dateOfBirthTextField.text, date != ""{
            dateOfBirthVerifyLabel.text = "👍🏻"
            dateOfBirthIsVerified = true
        }
        else {
            dateOfBirthVerifyLabel.text = "👎🏻"
            dateOfBirthIsVerified = false
        }
    }
    
    func verifyUserInfo() -> Bool {
        if(dateOfBirthIsVerified == true && passwordIsVerified == true && emailIsVerified == true && nameIsVerified == true) {
            return true
        }
        return false
    }
    
    func checkSignUpButton() {
        if(verifyUserInfo()) {
            signUpButton.isEnabled = true
        }
        else {
            signUpButton.isEnabled = false
        }
    }
}


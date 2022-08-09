//
//  LogInViewController.swift
//  QuickChat
//
//  Created by Nguyen Huy Tran on 7/2/22.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleSignInButton.layer.cornerRadius = GoogleSignInButton.frame.height / 2.0
        AccountCreateButton.layer.cornerRadius = AccountCreateButton.frame.height / 2.0
    }
    
    @IBOutlet weak var GoogleSignInButton: GIDSignInButton!
    
    @IBOutlet weak var AccountCreateButton: UIButton!
    
//    @IBAction func SignOut (_ sender: UIStoryboardSegue) {
//        
//        //Sign Out user
//        let firebaseAuth = Auth.auth()
//        do {
//          try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            let alertMessage = UIAlertController(title: "Error", message: signOutError.localizedDescription, preferredStyle: .alert)
//            let okButton = UIAlertAction(title: "Try Again", style: .cancel) { action in
//                return
//            }
//            alertMessage.addAction(okButton)
//            self.present(alertMessage, animated: true, completion: nil)
//        }
//        
//    }

 
}
// Google Log in
//extension LogInViewController {
//    func googleSignIn() {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//
//        // Start the sign in flow!
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
//
//          if let error = error {
//            // ... create an alert here
//              print(error.localizedDescription)
//            return
//          }
//
//          guard
//            let authentication = user?.authentication,
//            let idToken = authentication.idToken
//          else {
//            return
//          }
//
//          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                         accessToken: authentication.accessToken)
//
//          // Firebase Auth
//            Auth.auth().signIn(with: credential) { authResult, error in
//                if let error = error {
//                  let authError = error as NSError
//                  if isMFAEnabled, authError.code == AuthErrorCode.secondFactorRequired.rawValue {
//                    // The user is a multi-factor user. Second factor challenge is required.
//                    let resolver = authError
//                      .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
//                    var displayNameString = ""
//                    for tmpFactorInfo in resolver.hints {
//                      displayNameString += tmpFactorInfo.displayName ?? ""
//                      displayNameString += " "
//                    }
//                    self.showTextInputPrompt(
//                      withMessage: "Select factor to sign in\n\(displayNameString)",
//                      completionBlock: { userPressedOK, displayName in
//                        var selectedHint: PhoneMultiFactorInfo?
//                        for tmpFactorInfo in resolver.hints {
//                          if displayName == tmpFactorInfo.displayName {
//                            selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
//                          }
//                        }
//                        PhoneAuthProvider.provider()
//                          .verifyPhoneNumber(with: selectedHint!, uiDelegate: nil,
//                                             multiFactorSession: resolver
//                                               .session) { verificationID, error in
//                            if error != nil {
//                              print(
//                                "Multi factor start sign in failed. Error: \(error.debugDescription)"
//                              )
//                            } else {
//                              self.showTextInputPrompt(
//                                withMessage: "Verification code for \(selectedHint?.displayName ?? "")",
//                                completionBlock: { userPressedOK, verificationCode in
//                                  let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
//                                    .credential(withVerificationID: verificationID!,
//                                                verificationCode: verificationCode!)
//                                  let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
//                                    .assertion(with: credential!)
//                                  resolver.resolveSignIn(with: assertion!) { authResult, error in
//                                    if error != nil {
//                                      print(
//                                        "Multi factor finanlize sign in failed. Error: \(error.debugDescription)"
//                                      )
//                                    } else {
//                                      self.navigationController?.popViewController(animated: true)
//                                    }
//                                  }
//                                }
//                              )
//                            }
//                          }
//                      }
//                    )
//                  } else {
//                    self.showMessagePrompt(error.localizedDescription)
//                    return
//                  }
//                  // ...
//                  return
//                }
//                // User is signed in
//                // ...
//            }
//        }
//    }
//}

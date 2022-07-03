//
//  LogInViewController.swift
//  QuickChat
//
//  Created by Nguyen Huy Tran on 7/2/22.
//

import UIKit
import GoogleSignIn
class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleSignInButton.layer.cornerRadius = GoogleSignInButton.frame.height / 2.0
        AccountCreateButton.layer.cornerRadius = AccountCreateButton.frame.height / 2.0
    }
    
    @IBOutlet weak var GoogleSignInButton: GIDSignInButton!
    
    @IBOutlet weak var AccountCreateButton: UIButton!
    
}


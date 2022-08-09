//
//  HomeViewController.swift
//  QuickChat
//
//  Created by Nguyen Tran on 7/7/22.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        resignKeyboardWhenTouchScreen()
        sendButton.layer.cornerRadius = sendButton.frame.height / 2.0
        navigationItem.hidesBackButton = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        originalHeight = self.view.frame.size.height
        loadMess()
        listenToNewMess()
        
    }

    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var originalHeight:CGFloat?
    
    func listenToNewMess() {
        MessageManager.shared.addListenerToMessage {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: MessageManager.shared.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    func loadMess() {
        MessageManager.shared.loadMessages {
            self.tableView.reloadData()
        }
        
    }
    @IBAction func signOutBarButtonDidTap(_ sender: UIBarButtonItem) {
        //Sign Out user
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            let alertMessage = UIAlertController(title: "Error", message: signOutError.localizedDescription, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Try Again", style: .cancel) { action in
                return
            }
            alertMessage.addAction(okButton)
            self.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    @IBAction func sendButtonDidTap(_ sender: UIButton) {
        if let messegeBody = messageTextField.text, messegeBody != "", let user = Auth.auth().currentUser {
            MessageManager.shared.sendMessages(body: messegeBody, sender: user.uid)
            messageTextField.text = ""
        }
    }
}


extension HomeViewController: UITextViewDelegate {
    
    func resignKeyboardWhenTouchScreen() {
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        messageTextField.resignFirstResponder()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messageTextField.resignFirstResponder()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageManager.shared.numberOfMessage
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userID = Auth.auth().currentUser!.uid
        if(MessageManager.shared.messages[indexPath.row].sender == userID) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MesseageTableViewCell
            // fetch text
            cell.messageLabel.text = MessageManager.shared.messages[indexPath.row].message
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherMessageCell", for: indexPath) as! OtherMessageTableViewCell
            // fetch text
            cell.messageLabel.text = MessageManager.shared.messages[indexPath.row].message
            return cell
        }
    }
    
    
}

// for keyboard managing
extension HomeViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.size.height == originalHeight {
                self.view.frame.size.height -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.size.height != originalHeight {
            self.view.frame.size.height = originalHeight!
        }
    }
}

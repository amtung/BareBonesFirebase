//
//  ShareLinkViewController.swift
//  BareBonesFirebase
//
//  Created by Annie Tung on 2/13/17.
//  Copyright © 2017 Annie Tung. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ShareLinkViewController: UIViewController {

    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    var databaseReference: FIRDatabaseReference!
    var user: FIRUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.databaseReference = FIRDatabase.database().reference().child("links")
        FIRAuth.auth()?.signInAnonymously(completion: { (user: FIRUser?, error: Error?) in
            
            if let error = error {
                print("Sign in anonymously error: \(error)")
            } else {
                self.user = user
            }
        })
    }
    
    @IBAction func shareLink(_ sender: UIButton) {
        shareToFirebase()
    }
    
    func shareToFirebase() {
        let linkRef = databaseReference.childByAutoId()
        let link = Link(key: linkRef.key, url: self.linkTextField.text!, comment: self.commentTextView.text)
        let dict = link.asDictionary
        
        linkRef.setValue(dict) { (error, reference) in
            
            if let error = error {
                print("Sharing to firebase error: \(error)")
            }
            else {
                print(reference)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}








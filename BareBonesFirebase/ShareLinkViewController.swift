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
import FirebaseStorage

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
        APIRequestManager.manager.getData(endPoint: self.linkTextField.text!) { (data) in
            
            let linkRef = self.databaseReference.childByAutoId()
            if let validData = data,
                let image = UIImage(data: validData) {
                let storage = FIRStorage.storage()
                let storageRef = storage.reference(forURL: "gs://barebonesfirebase-bed15.appspot.com")
                let spaceRef = storageRef.child("images/\(linkRef.key)")
                
                // downsize the image by compressing it
                let jpeg = UIImageJPEGRepresentation(image, 0.7)
                
                let metadata = FIRStorageMetadata()
                metadata.cacheControl = "public,max-age=300";
                metadata.contentType = "image/jpeg";
                
                let _ = spaceRef.put(jpeg!, metadata: metadata) { (metadata, error) in
                    guard metadata != nil else {
                        print("put error")
                        return
                    }
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    //let downloadURL = metadata.downloadURL
                }
            }
            
            let link = Link(key: linkRef.key, url: self.linkTextField.text!, comment: self.commentTextView.text)
            let dict = link.asDictionary
            
            // put in the database
            linkRef.setValue(dict) { (error, reference) in
                if let error = error {
                    print(error)
                }
                else {
                    print(reference)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}








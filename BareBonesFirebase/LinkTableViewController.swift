//
//  LinkTableViewController.swift
//
//
//  Created by Annie Tung on 2/13/17.
//
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class LinkTableViewController: UITableViewController {
    
    var databaseReference: FIRDatabaseReference!
    var links = [Link]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.databaseReference = FIRDatabase.database().reference().child("links")
//        getLinks()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getLinks()
    }
    
    func getLinks() {
        databaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var newLinks = [Link]()
            
            for child in snapshot.children {
                dump(child)
                
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? [String : String] {
                    
                    let link = Link(key: snap.key,
                                    url: valueDict["url"] ?? "",
                                    comment: valueDict["comment"] ?? "")
                    // we construct the arr then populate tableview w. data that came back from firebase
                    newLinks.append(link)
                }
            }
            self.links = newLinks
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "linkCell", for: indexPath) as! LinkTableViewCell
        
        let link = links[indexPath.row]
        cell.linkLabel.text = link.url
        cell.commentLabel.text = link.comment
        
        let storage = FIRStorage.storage()
        // create a storage ref from our storage servie
        let storageRef = storage.reference() // (forURL: "gs://barebonesfirebase-bed15.appspot.com")
        let spaceRef = storageRef.child("images/\(link.key)")
        spaceRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(error)
            }
            else {
                // data for "images/island.jpg" is returned
                if let data = data {
                    let image = UIImage(data: data)
                    cell.linkImageView.image = image
                }
            }
        }
        return cell
    }
    
    @IBAction func addLink(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let svc = storyboard.instantiateViewController(withIdentifier: "shareLinkVC")
        self.present(svc, animated: true, completion: nil)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

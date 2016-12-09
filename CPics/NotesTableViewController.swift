//
//  NotesTableViewController.swift
//  CPics
//
//  Created by Justin Moore on 12/1/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import Parse

class NotesTableViewController: UITableViewController {

    let Server = ParseServer.sharedInstance
    var arrayOfNotes: [PFObject]?
    var member: PFObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.tableFooterView = nil
        tableView.tableFooterView = UIView()
        
        if let member = Server.member {
            self.member = member
            loadNotes()
        }
    
    }

    override func viewWillAppear(_ animated: Bool) {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.tabBarController?.navigationItem.rightBarButtonItem = add
    }
    
    func addTapped() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add Note", message: "Enter a text", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            if (textField?.text?.characters.count)! > 0 {
                let newNote = PFObject(className: "MemberNotes")
                newNote["note"] = textField?.text
                newNote.setObject(self.member!, forKey: "member")
                newNote.setObject(PFUser.current()!, forKey: "staff")
                newNote.saveEventually { (done: Bool, err: Error?) in
                    if done {
                        self.arrayOfNotes?.append(newNote)
                        self.tableView.reloadData()
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadNotes() {
        arrayOfNotes?.removeAll()
        let query = PFQuery(className: "MemberNotes")
        query.limit = 1000
        query.whereKey("member", equalTo: member!)
        query.findObjectsInBackground { (notes: [PFObject]?, err: Error?) in
            if notes != nil {
                self.arrayOfNotes = notes!
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfNotes?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath) as! NoteTableViewCell
        
        let lbl = cell.viewWithTag(5) as! UILabel
        
        let note = arrayOfNotes?[indexPath.row]
        let string = note?["note"] as? String ?? ""
        lbl.text = string
        lbl.textColor = UIColor(white: 114/255, alpha: 1)
        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ManageEventTableViewController.swift
//  Gale
//
//  Created by Ken Cheng on 12/2/16.
//  Copyright © 2016 cpsc437. All rights reserved.
//

import UIKit
import SwiftyJSON

class ManageEventTableViewController: UITableViewController {
    
    var jwt: String!
    var event_desc_list = [String]()
    var event_id_list = [Int]()
    var event_id: Int!
    
    func load_events(){
        let url:URL = URL(string: "http://localhost:4000/api/event")!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(jwt, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task_create = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error!)                                 // some fundamental network error
                return
            }
            //            }
            let response = JSON(data:data)
            if(response["error"]==true){
                print("load event fail")
            }else{
                //print(response)
                let reqs = response["payload"]["owned_events"].arrayValue
                //print(reqs)
                for sub:JSON in reqs{
                    //print(sub["user"])
                    self.event_desc_list.append(sub["description"].string!)
                    self.event_id_list.append(sub["id"].int!)
                }
                print(self.event_desc_list)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task_create.resume()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_events()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return event_desc_list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageEventCell", for: indexPath) as! ManageEventTableViewCell
        let event_detail = event_desc_list[indexPath.row]
//        let event_id = event_id_list[indexPath.row]
        
        cell.event_desc.text = event_detail

        // Configure the cell...

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageEventCell", for: indexPath) as! ManageEventTableViewCell
//        cell.backgroundColor = UIColor.gray
//        let friend_name = friend_displayed_name_list[indexPath.row]
//        cell.friend_name.text = friend_name
        event_id = event_id_list[indexPath.row]
        performSegue(withIdentifier: "event_detail", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "event_detail"{
            let destVc = segue.destination as? EventDetailViewController
            destVc!.jwt = jwt
            destVc!.event_id = event_id
        }
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

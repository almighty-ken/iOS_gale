//
//  FriendReqTableViewController.swift
//  Gale
//
//  Created by Ken Cheng on 11/30/16.
//  Copyright © 2016 cpsc437. All rights reserved.
//

import UIKit
import SwiftyJSON

class FriendReqTableViewController: UITableViewController {
    
    var req_list = [String]()
    var req_id = [Int]()
    var jwt: String!
    
    func load_reqs(){
        let url:URL = URL(string: "http://localhost:4000/api/friendreq")!
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
                print("friend req fetch fail")
            }else{
                print("success")
                //print(response)
                let reqs = response["payload"].arrayValue
                //print(reqs)
                for sub:JSON in reqs{
                    //print(sub["user"])
                    self.req_list.append(sub["user"].string!)
                    self.req_id.append(sub["id"].int!)
                }
                print("friend req loaded")
                print(self.req_list)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task_create.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.load_reqs()
        //print(req_list)
        
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
        //print("d2")
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print(req_list.count)
        return req_list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("set text")
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        
        let req = req_list[indexPath.row]
        
        cell.friend_name.text = req
        
        cell.tapAction = { (cell) in
            print("button pressed")
            let id = self.req_id[tableView.indexPath(for: cell)!.row]
            self.add_friend(req_id: id, row:tableView.indexPath(for: cell)!.row)
//            cell.button_text.text = "Accepted"
        }

        // Configure the cell...

        return cell
    }
 
    
    func add_friend(req_id: Int, row: Int){
        let url:URL = URL(string: "http://localhost:4000/api/friendreq/\(req_id)")!
        var request = URLRequest(url: url)
        let dictionary: [String:String]
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(jwt, forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        dictionary = ["action": "accept"]
        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary)
        
        let task_create = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error!)                                 // some fundamental network error
                return
            }
            //            }
            let response = JSON(data:data)
            if(response["error"]==true){
                print("friend req accept fail")
            }else{
                print("success")
                let _ = self.req_list.remove(at: row)
                let _ = self.req_id.remove(at: row)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task_create.resume()
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

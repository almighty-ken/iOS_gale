//
//  ChooseFriendViewController.swift
//  Gale
//
//  Created by Ken Cheng on 11/27/16.
//  Copyright © 2016 cpsc437. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChooseFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var jwt: String!
    var event_description: String!
    var friend_name_list = [String]()
    var friend_displayed_name_list = [String]()
    var selected_friends = [String]()

    @IBOutlet weak var friend_table: UITableView!
    
    func fetch_friend_list(){
        let url:URL = URL(string: "http://localhost:4000/api/friend")!
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
                print("friend list fetch fail")
            }else{
                print("success")
                //print(response)
                let reqs = response["payload"].arrayValue
                //print(reqs)
                for sub:JSON in reqs{
                    //print(sub["user"])
                    self.friend_name_list.append(sub["username"].string!)
                    self.friend_displayed_name_list.append(sub["name"].string!)
                }
                print("friend list loaded")
                print(self.friend_displayed_name_list)
                DispatchQueue.main.async {
                    self.friend_table.reloadData()
                }
            }
        }
        task_create.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(event_description)
        friend_table.delegate = self
        friend_table.dataSource = self
        self.fetch_friend_list()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //print("d2")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print(req_list.count)
        return friend_name_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        print("set text")
        let cell = tableView.dequeueReusableCell(withIdentifier: "friend_cell", for: indexPath) as! InviteTableViewCell
        
        let friend_name = friend_displayed_name_list[indexPath.row]
        
        cell.friend_name.text = friend_name
        
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableView.dequeueReusableCell(withIdentifier: "friend_cell", for: indexPath) as! InviteTableViewCell
        cell.backgroundColor = UIColor.gray
        let friend_name = friend_displayed_name_list[indexPath.row]
        cell.friend_name.text = friend_name

        selected_friends.append(friend_name_list[indexPath.row])
    }
    
    @IBAction func event_create(_ sender: Any) {
        print(selected_friends)
        let url:URL = URL(string: "http://localhost:4000/api/event")!
        var request = URLRequest(url: url)
        let dictionary: [String:Any]
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(jwt, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        dictionary = ["description": self.event_description,"time":"2016-12-01T16:11:33.486649Z","invitees":selected_friends]
        let j = JSON(dictionary)
        //print(j)
        request.httpBody = try! j.rawData()
        
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
                let dialog = UIAlertController(title: "Event Created",
                                               message: "Confirm to continue",
                                               preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default,handler: {
                    [unowned self] (action) -> Void in
                    self.performSegue(withIdentifier: "event_created", sender: self)
                })
                dialog.addAction(action)
                self.present(dialog,animated: false,completion: nil)
//                let _ = self.req_list.remove(at: row)
//                let _ = self.req_id.remove(at: row)
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
            }
        }
        task_create.resume()
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

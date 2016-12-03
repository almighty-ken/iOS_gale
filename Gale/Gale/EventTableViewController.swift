//
//  EventTableViewController.swift
//  Gale
//
//  Created by Ken Cheng on 12/1/16.
//  Copyright © 2016 cpsc437. All rights reserved.
//

import UIKit
import SwiftyJSON
import UserNotificationsUI
import UserNotifications

class EventTableViewController: UITableViewController {
    
    var jwt: String!
    var event_desc_list = [String]()
    var event_host_list = [String]()
    var event_time_list = [String]()
    var event_id_list = [Int]()
    
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
                let reqs = response["payload"]["pending_events"].arrayValue
                //print(reqs)
                for sub:JSON in reqs{
                    //print(sub["user"])
                    self.event_desc_list.append(sub["description"].string!)
                    self.event_host_list.append(sub["owner_name"].string!)
                    self.event_time_list.append(sub["time"].string!)
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
        self.load_events()
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

    func treat_event(event_id: Int, action: String){
        let url:URL = URL(string: "http://localhost:4000/api/event/\(event_id)")!
        var request = URLRequest(url: url)
        let dictionary: [String:Any]
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(jwt, forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        dictionary = ["action": action]
        let j = JSON(dictionary)
        //print(j)
        request.httpBody = try! j.rawData()
        
        let task_create = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error!)
                return
            }
            let response = JSON(data:data)
            if(response["error"]==true){
                print("event response fail")
                print(response["payload"]["message"].string!)
            }else{
                print("success")
                
            }
        }
        task_create.resume()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        let event_detail = event_desc_list[indexPath.row]
        let event_host = event_host_list[indexPath.row]
        let event_id = event_id_list[indexPath.row]
        let event_time = event_time_list[indexPath.row]
        
        cell.event_detail.text = event_detail
        cell.event_host.text = event_host
        cell.event_time.text = event_time
        
        cell.tapAction1 = { (cell) in
            // decline
            self.treat_event(event_id: event_id, action: "decline")
            let _ = self.event_id_list.remove(at: indexPath.row)
            let _ = self.event_desc_list.remove(at: indexPath.row)
            let _ = self.event_host_list.remove(at:indexPath.row)
            let _ = self.event_time_list.remove(at:indexPath.row)
            self.tableView.reloadData()
        }
        
        cell.tapAction2 = { (cell) in
            // accept
            self.treat_event(event_id: event_id, action: "accept")
            let _ = self.event_id_list.remove(at: indexPath.row)
            let _ = self.event_desc_list.remove(at: indexPath.row)
            let _ = self.event_host_list.remove(at: indexPath.row)
            let _ = self.event_time_list.remove(at:indexPath.row)
            self.tableView.reloadData()
            
            //create reminder
            print("set notification for event")
            let content = UNMutableNotificationContent()
            content.title = "Event Reminder"
            content.subtitle = event_detail
            content.body = event_time
            content.sound = UNNotificationSound.default()
            
            var calendar = Calendar(identifier: .gregorian)
            let myLocale = Locale(identifier: "bg_BG")
            calendar.locale = myLocale
            let formatter = ISO8601DateFormatter()
            let date = formatter.date(from: event_time)
            print(event_time)
            let components = calendar.dateComponents([.day, .month, .year, .minute, .hour, .second], from: date!)
            
            print(components)
//            let dateComponents = calendar.dateComponents([.day, .month, .year], from: date!)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier:"event_reminder", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
//            UNUserNotificationCenter.current().delegate = self
//            UNUserNotificationCenter.current().add(request){(error) in
//                
//                if (error != nil){
//                    
//                    print(error?.localizedDescription)
//                }
//            }
        }
        
        // Configure the cell...

        return cell
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

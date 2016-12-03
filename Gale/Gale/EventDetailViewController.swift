//
//  EventDetailViewController.swift
//  Gale
//
//  Created by Ken Cheng on 12/2/16.
//  Copyright © 2016 cpsc437. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventDetailViewController: UIViewController {
    
    @IBOutlet weak var event_description: UILabel!
    @IBOutlet weak var event_time: UILabel!
    
    
    var jwt: String!
    var event_id: Int!
    var event_desc: String!
    var event_t: String!
    var name_accept = [String]()
    var name_pending = [String]()
    var name_decline = [String]()

    func load_event(id: Int){
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
                    if(sub["id"].int! == self.event_id){
                        self.event_desc = sub["description"].string!
                        self.event_t = sub["time"].string!
                        let accept = sub["accepted_invitees"].arrayValue
                        for n:JSON in accept{
                            self.name_accept.append(n["name"].string!)
                        }
                        let pending = sub["pending_invitees"].arrayValue
                        for n:JSON in pending{
                            self.name_pending.append(n["name"].string!)
                        }
                        let decline = sub["rejected_invitees"].arrayValue
                        for n:JSON in decline{
                            self.name_decline.append(n["name"].string!)
                        }
                    }
                    // load data into label
                    print(self.event_desc)
                    print(self.event_t)
                    print(self.name_accept)
                    print(self.name_decline)
                    print(self.name_pending)
                    
                    DispatchQueue.main.async {
                        self.event_description.text = self.event_desc
                        self.event_time.text = self.event_t
                        for i in 0..<(self.name_pending.count){
                            if(i>5){
                                continue
                            }
                            if let theLabel = self.view.viewWithTag(i+1) as? UILabel {
                                theLabel.text = self.name_pending[i]
                            }
                        }
                        for i in 0..<(self.name_accept.count){
                            if(i>2){
                                continue
                            }
                            if let theLabel = self.view.viewWithTag(11+i) as? UILabel {
                                theLabel.text = self.name_accept[i]
                            }
                        }
                        for i in 0..<(self.name_decline.count){
                            if(i>2){
                                continue
                            }
                            if let theLabel = self.view.viewWithTag(21+i) as? UILabel {
                                theLabel.text = self.name_decline[i]
                            }
                        }
//                        self.loadView()
                    }
                    
                    
                }
            }
        }
        task_create.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(event_id)
        // Do any additional setup after loading the view.
        
        load_event(id: event_id)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

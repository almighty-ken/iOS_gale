//
//  CreateEventViewController.swift
//  Gale
//
//  Created by Ken Cheng on 11/27/16.
//  Copyright © 2016 cpsc437. All rights reserved.
//

import UIKit
import SwiftyJSON

class CreateEventViewController: UIViewController {
    
    var jwt: String!
    @IBOutlet weak var event_description: UITextView!
    @IBOutlet weak var date_picker_outlet: UIDatePicker!
    
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
//                for sub:JSON in reqs{
//                    //print(sub["user"])
//                    
//                }
                if !reqs.isEmpty{
                    //perform segue
                    DispatchQueue.main.async {
                        let dialog = UIAlertController(title: "New Event",
                                                       message: "Press to respond",
                                                       preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default,handler: {
                            [unowned self] (action) -> Void in
                            self.performSegue(withIdentifier: "new_event", sender: self)
                        })
                        dialog.addAction(action)
                        self.present(dialog,animated: false,completion: nil)
                    }
                    
                }
                
            }
        }
        task_create.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_events()
//         print(jwt!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func move_to_choose_friend(_ sender: Any) {
        performSegue(withIdentifier: "event_friend", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "new_event"{
            let destVc = segue.destination as? EventTableViewController
            destVc!.jwt = jwt
        }
        if segue.identifier == "manage_friend"{
            let destVc = segue.destination as? FriendReqViewController
            destVc!.jwt = jwt
        }
        if segue.identifier == "event_view"{
            let destVc = segue.destination as? EventTableViewController
            destVc!.jwt = jwt
        }
        if segue.identifier == "event_friend"{
            let destVc = segue.destination as? ChooseFriendViewController
            destVc!.jwt = jwt
            destVc!.event_description = self.event_description.text
            
//            let formatter = DateFormatter()
            let formatter = ISO8601DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
            let strDate = formatter.string(from: self.date_picker_outlet.date)
            print(strDate)
            destVc!.event_time = strDate
        }
        if segue.identifier == "manage_event"{
            let destVc = segue.destination as? ManageEventTableViewController
            destVc!.jwt = jwt
        }
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

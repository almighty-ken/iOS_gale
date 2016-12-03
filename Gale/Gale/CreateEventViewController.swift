//
//  CreateEventViewController.swift
//  Gale
//
//  Created by Ken Cheng on 11/27/16.
//  Copyright © 2016 cpsc437. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {
    
    var jwt: String!
    @IBOutlet weak var event_description: UITextView!
    @IBOutlet weak var date_picker_outlet: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
            let strDate = formatter.string(from: self.date_picker_outlet.date)
            print(strDate)
            
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

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
    
    var jwt: String!
    var event_id: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(event_id)
        // Do any additional setup after loading the view.
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

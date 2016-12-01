//
//  FriendReqViewController.swift
//  Gale
//
//  Created by Ken Cheng on 11/29/16.
//  Copyright © 2016 cpsc437. All rights reserved.
//

import UIKit
import SwiftyJSON

class FriendReqViewController: UIViewController {
    var jwt: String!

    
    @IBOutlet weak var friend_name: UITextField!
    
    @IBAction func AddFriend(_ sender: Any) {
        let url:URL = URL(string: "http://localhost:4000/api/friendreq")!
        var request = URLRequest(url: url)
        //var responseObject : [String:Any]!
        let dictionary: [String:String]
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(jwt, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        dictionary = ["username": friend_name.text!]
        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary)
        
        let task_create = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error!)                                 // some fundamental network error
                return
            }
            
            
            let response = JSON(data:data)
            print(response["error"])
            print(response["payload"]["message"])
            if(response["error"]==true){
                print("Friend Req Fail")
                DispatchQueue.main.async {
                    self.friend_name.text = ""
                    let dialog = UIAlertController(title: "Friend Request",
                                                   message: "Failed",
                                                   preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "Retry", style: UIAlertActionStyle.default,handler: nil)
                    dialog.addAction(action)
                    self.present(dialog,animated: false,completion: nil)
                }
            }else{
                print("success")
                DispatchQueue.main.async {
                    self.friend_name.text = ""
                    let dialog = UIAlertController(title: "Friend Request",
                                                   message: "Sent",
                                                   preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "Sure", style: UIAlertActionStyle.default,handler: nil)
                    dialog.addAction(action)
                    self.present(dialog,animated: false,completion: nil)
                }
                
            }
            
        }
        task_create.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "req_list"){
            print("passing jwt")
            let destVc = segue.destination as? FriendReqTableViewController
            destVc!.jwt = jwt
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

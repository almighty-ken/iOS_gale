//
//  LogInViewController.swift
//  Gale
//
//  Created by Ken Cheng on 11/27/16.
//  Copyright © 2016 cpsc437. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var user_name: UITextField!
    @IBOutlet weak var user_password: UITextField!
    
    @IBAction func log_in(_ sender: Any) {
        let url = URL(string: "http://localhost:4000/api/login")
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        //request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        request.httpMethod = "POST"
        
        let dictionary = ["username": user_name, "password": user_password]
        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error!)                                 // some fundamental network error
                return
            }
            
            do {
                let responseObject = try JSONSerialization.jsonObject(with: data)
                print(responseObject)
            } catch let jsonError {
                print(jsonError)
                print(String(data: data, encoding: .utf8)!)   // often the `data` contains informative description of the nature of the error, so let's look at that, too
            }
        }
        task.resume()
        // TODO: Take response and decide segue
        
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

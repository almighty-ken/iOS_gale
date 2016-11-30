//
//  SignUpViewController.swift
//  Gale
//
//  Created by Ken Cheng on 11/27/16.
//  Copyright © 2016 cpsc437. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var user_name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var displayed_name: UITextField!
    
    var jwt: String!


    @IBAction func sign_up(_ sender: Any) {
        let url:URL = URL(string: "http://localhost:4000/api/user")!
        var request = URLRequest(url: url)
        var responseObject : [String:Any]!
        let dictionary: [String:String]
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        //request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        request.httpMethod = "POST"
        
        dictionary = ["username": user_name.text!, "password": password.text!,"name":displayed_name.text!]
        request.httpBody = try! JSONSerialization.data(withJSONObject: dictionary)
        
        let task_create = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error!)                                 // some fundamental network error
                return
            }
            
            do {
                responseObject = try JSONSerialization.jsonObject(with: data) as? [String:Any]
                print(responseObject)
                if (responseObject["error"] as? String == "true"){
                    print("create user fail")
                }else{
                    print("user created")
                    self.login(user_name: self.user_name.text!,user_password: self.password.text!)
                    
//
                }
            } catch let jsonError {
                print(jsonError)
                print(String(data: data, encoding: .utf8)!)   // often the `data` contains informative description of the nature of the error, so let's look at that, too
            }
        }
        task_create.resume()
        
        
        
    }
    
    func login(user_name:String, user_password:String){
        let url:URL = URL(string: "http://localhost:4000/api/login")!
        var request = URLRequest(url: url)
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
                let responseObject = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let payload = responseObject?["payload"] as? [String: Any]{
                    if let jwt = payload["jwt"] as? String{
//                        print(jwt)
                        DispatchQueue.main.async {
                            self.jwt = jwt
                            self.performSegue(withIdentifier: "signup_jwt", sender: nil)
                        }
                        
                    }
                }
                
                //                print(responseObject[payload][jwt])
                //                jwt = responseObject.payload.jwt
            } catch let jsonError {
                print(jsonError)
                print(String(data: data, encoding: .utf8)!)   // often the `data` contains informative description of the nature of the error, so let's look at that, too
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("preparing segue")
        if segue.identifier == "signup_jwt"{
            print("passing jwt")
            let destVc = segue.destination as? CreateEventViewController
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

//
//  ViewController.swift
//  Gale
//
//  Created by Ken Cheng on 11/26/16.
//  Copyright © 2016 cpsc437. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogIn(_ sender: Any) {
        print("Initiate log in procedure")
    }

    @IBAction func SignUp(_ sender: Any) {
        print("Initiate sign up procedure")
    }

}


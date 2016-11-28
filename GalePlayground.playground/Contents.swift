//: Playground - noun: a place where people can play

import UIKit

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


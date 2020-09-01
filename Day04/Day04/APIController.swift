//
//  APIController.swift
//  Day04
//
//  Created by Julia SEMYZHENKO on 10/4/19.
//  Copyright © 2019 Julia SEMYZHENKO. All rights reserved.
//

import UIKit
import Foundation

class APIController {

    weak var delegate: APITwitterDelegate?
    let token: String
    init(delegate: APITwitterDelegate, token: String)
    {
        self.delegate = delegate
        self.token = token
    }
    
    func getTwitter(string: String)
    {
        var tweets: [Tweet] = []
        
        let q = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let request = NSMutableURLRequest(url: URL(string : "https://api.twitter.com/1.1/search/tweets.json?q=\(q)&count=100&result_type=recent")!)
        request.httpMethod = "GET"
        request.setValue("Bearer " +  self.token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            if let err = error {
                if let error: APITwitterDelegate = self.delegate {
                    error.processError(errors: [err])
                }
            } else if let d = data {
                do {
                    if let responseObject = try JSONSerialization.jsonObject(with: d, options: []) as? [String:AnyObject],
                        let arrayStatuses = responseObject["statuses"] as? [[String:AnyObject]] {
                        print("Data items count: \(arrayStatuses.count)")
                        for status in arrayStatuses {
                            let text = status["text"] as! String
                            let user = status["user"]?["name"]  as! String
                            if let date = status["created_at"] as? String {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
                                if let date = dateFormatter.date(from: date) {
                                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                                    let newDate = dateFormatter.string(from: date)
                                    tweets.append(Tweet(name: user, text: text, date: newDate))
                                }
                            }
                        }
                    }
                    if let done: APITwitterDelegate = self.delegate {
                        done.processReceivedTweets(tweets: tweets)
                    }
                } catch _{
                    print("Connection lost or something happend")
                }
            }
        })
        task.resume()

    }
    
}
    

//let task = URLSession.shared.dataTask(with: my_mutableURLRequest as URLRequest, completionHandler:

//result_type - recent
//count - 100

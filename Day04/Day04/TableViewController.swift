//
//  TableViewController.swift
//  Day04
//
//  Created by Julia SEMYZHENKO on 10/4/19.
//  Copyright © 2019 Julia SEMYZHENKO. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, APITwitterDelegate {

    var token :String?
    var apiController : APIController?
    var tweets : [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        initToken()
    }
    
    func processReceivedTweets(tweets: [Tweet])
    {
        print("processTweet")
        self.tweets = tweets
        for t in tweets {
            print(t)
        }
        DispatchQueue.main.async
        {
            self.tableView.reloadData()
        }
        
    }
    
    func processError(errors: [Error])
    {
        print("error: \(errors)")
    }
    
    
    func initToken()
    {
        let CUSTUMER_KEY = "lo0j5t40X6nt8Wj3YBzg"
        let CUSTUMER_SECRET = "39PPCILZq7aDCaA2eN8wRp6v9uIllYBaANLLtA1sPlY"
        let bearer = ((CUSTUMER_KEY + ":" + CUSTUMER_SECRET).data(using: String.Encoding.utf8))?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        let url = URL(string: "https://api.twitter.com/oauth2/token")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Basic " + bearer!, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            print(response!)
            guard let data = data, error == nil else {
                print(error!)
                return
            }
            do {
                if let dic: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                {
                        print(dic)
                        self.token = (dic["access_token"] as? String)!
                        print("token twitter : \(String(describing: self.token))")
                    self.apiController = APIController(delegate: self, token: self.token!)
                        self.apiController?.getTwitter(string: "ecole 42")
                }
            }
            catch (let err)
            {
                print(err)
            }
        }
        task.resume()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("Tweets count: \(self.tweets.count)")
        return self.tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("cellForRowAt")
        
        var cellReturn : UITableViewCell?
        if let cellTweet = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? cell
        {
            cellTweet.nameLabel.text = self.tweets[indexPath.row].name
            cellTweet.dateLabel.text = self.tweets[indexPath.row].date
            cellTweet.textTweetLabel.text = self.tweets[indexPath.row].text
            print(cellTweet)
            cellReturn = cellTweet
        }
        return cellReturn!
    }
      
}

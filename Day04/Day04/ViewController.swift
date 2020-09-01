//
//  ViewController.swift
//  Day04
//
//  Created by Julia SEMYZHENKO on 10/4/19.
//  Copyright © 2019 Julia SEMYZHENKO. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APITwitterDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

  
    var token :String?
    var apiController : APIController?
    var tweets : [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var researchTextFeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = (self as UITableViewDataSource)
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
        self.displayAllert(message: "error: \(errors)")
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
                self.displayAllert(message: "error")
                return
            }
            do {
                if let dic: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                {
                    print(dic)
                    self.token = (dic["access_token"] as? String)!
                    print("token twitter : \(String(describing: self.token))")
                    self.apiController = APIController(delegate: self, token: self.token!)
                    self.apiController?.getTwitter(string: "school 42")
                }
            }
            catch (let err)
            {
                self.displayAllert(message: "error: \(err)")
            }
        }
        task.resume()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("Tweets count: \(self.tweets.count)")
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let searchF: String = textField.text!
        self.apiController?.getTwitter(string: searchF)
        researchTextFeild.resignFirstResponder()
        return true
    }
    func displayAllert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
        
    }


}

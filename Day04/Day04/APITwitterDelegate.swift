//
//  File.swift
//  Day04
//
//  Created by Julia SEMYZHENKO on 10/4/19.
//  Copyright © 2019 Julia SEMYZHENKO. All rights reserved.
//

import Foundation

protocol APITwitterDelegate: class {
    func processReceivedTweets(tweets : [Tweet])
    func processError(errors : [Error])
}

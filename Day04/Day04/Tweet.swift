//
//  Tweet.swift
//  Day04
//
//  Created by Julia SEMYZHENKO on 10/4/19.
//  Copyright © 2019 Julia SEMYZHENKO. All rights reserved.
//

import Foundation

struct Tweet: CustomStringConvertible {
    let name: String
    let text: String
    let date: String
    var description: String
    {
        return ("\(name): \(text)")
    }
}

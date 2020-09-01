//
//  cell.swift
//  Day04
//
//  Created by Julia SEMYZHENKO on 10/4/19.
//  Copyright © 2019 Julia SEMYZHENKO. All rights reserved.
//

import UIKit

class cell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var textTweetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

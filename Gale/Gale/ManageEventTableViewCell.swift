//
//  ManageEventTableViewCell.swift
//  Gale
//
//  Created by Ken Cheng on 12/2/16.
//  Copyright © 2016 cpsc437. All rights reserved.
//

import UIKit

class ManageEventTableViewCell: UITableViewCell {

    @IBOutlet weak var event_desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

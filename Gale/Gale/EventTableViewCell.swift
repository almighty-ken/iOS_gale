//
//  EventTableViewCell.swift
//  Gale
//
//  Created by Ken Cheng on 12/1/16.
//  Copyright © 2016 cpsc437. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var event_detail: UILabel!
    @IBOutlet weak var event_host: UILabel!
    @IBOutlet weak var event_time: UILabel!
    
    var tapAction1: ((UITableViewCell) -> Void)?
    var tapAction2: ((UITableViewCell) -> Void)?
    
    @IBAction func decline_event(_ sender: Any) {
        tapAction1?(self)
    }
    
    @IBAction func accept_event(_ sender: Any) {
        tapAction2?(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
